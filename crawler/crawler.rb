require 'log4r'
require 'yajl'
require 'digest'
require 'em-http'
require 'em-stathat'

require_relative 'obfuscate.rb'

include EM

##
## Setup
##

PAGE_LIMIT = 100

StatHat.config do |c|
  c.ukey  = ENV['STATHATKEY']
  c.email = 'ilya@igvita.com'
end

@log = Log4r::Logger.new('github')
@log.add(Log4r::StdoutOutputter.new('console', {
  :formatter => Log4r::PatternFormatter.new(:pattern => "[#{Process.pid}:%l] %d :: %m")
}))

if !ENV['GITHUB_TOKEN']
  @log.error "No GITHUB_TOKEN environment variable defined."
  raise "No GITHUB_TOKEN environment variable defined."
end

##
## Crawler
##

EM.run do
  stop = Proc.new do
    puts "Terminating crawler"
    EM.stop
  end

  Signal.trap("INT",  &stop)
  Signal.trap("TERM", &stop)

  @latest = []
  @latest_key = lambda { |e| "#{e['id']}" }
  @etags = {}  # Track ETags for each page

  process = Proc.new do
    # First, probe page 1 with conditional GET
    req1 = HttpRequest.new("https://api.github.com/events?per_page=#{PAGE_LIMIT}&page=1", {
      :inactivity_timeout => 5,
      :connect_timeout => 5
    }).get({
      :head => {
        'user-agent' => 'gharchive.org',
        'Authorization' => 'token ' + ENV['GITHUB_TOKEN'],
        'If-None-Match' => @etags[1]
      }.compact
    })

    req1.callback do
      begin
        # If page 1 hasn't changed (304 Not Modified), skip this cycle
        if req1.response_header.status == 304
          @log.debug "Page 1 not modified, skipping"
          EM.add_timer(0.2, &process)
          return
        end

        # Page 1 changed, update ETag and fetch pages 2 & 3
        @etags[1] = req1.response_header.etag

        # Fetch pages 2 and 3 in parallel (GitHub only provides up to 300 events)
        multi = EM::MultiRequest.new

        req2 = HttpRequest.new("https://api.github.com/events?per_page=#{PAGE_LIMIT}&page=2", {
          :inactivity_timeout => 5,
          :connect_timeout => 5
        }).get({
          :head => {
            'user-agent' => 'gharchive.org',
            'Authorization' => 'token ' + ENV['GITHUB_TOKEN'],
            'If-None-Match' => @etags[2]
          }.compact
        })

        req3 = HttpRequest.new("https://api.github.com/events?per_page=#{PAGE_LIMIT}&page=3", {
          :inactivity_timeout => 5,
          :connect_timeout => 5
        }).get({
          :head => {
            'user-agent' => 'gharchive.org',
            'Authorization' => 'token ' + ENV['GITHUB_TOKEN'],
            'If-None-Match' => @etags[3]
          }.compact
        })

        multi.add(:page2, req2)
        multi.add(:page3, req3)

        multi.callback do
          # Update ETags
          @etags[2] = req2.response_header.etag if req2.response_header.status == 200
          @etags[3] = req3.response_header.etag if req3.response_header.status == 200

          # Parse all responses
          page1_events = Yajl::Parser.parse(req1.response)
          page2_events = req2.response_header.status == 200 ? Yajl::Parser.parse(req2.response) : []
          page3_events = req3.response_header.status == 200 ? Yajl::Parser.parse(req3.response) : []

          # Merge all events from the 3 pages (GitHub's max is 300 events)
          latest = page1_events + page2_events + page3_events
          urls = latest.collect(&@latest_key)
          new_events = latest.reject {|e| @latest.include? @latest_key.call(e)}

          @latest = urls

          # Determine archive filename based on current time, before processing events
          current_processing_time = Time.now
          timestamp = current_processing_time.strftime('%Y-%m-%d-%-k')
          archive = "data/#{timestamp}.json"

          # Open or rotate file based on the current time's archive path
          if @file.nil? || (archive != @file.to_path)
            if !@file.nil?
              @log.info "Rotating archive. Current: #{@file.to_path}, New: #{archive}"
              @file.close
            end
            @file = File.new(archive, "a+")
          end

          new_events.each do |event|
            @file.puts(Yajl::Encoder.encode(Obfuscate.email(event)))
          end

          remaining = req1.response_header.raw['X-RateLimit-Remaining']
          reset = Time.at(req1.response_header.raw['X-RateLimit-Reset'].to_i)
          @log.info "Found #{new_events.size} new events (page1: #{page1_events.size}, page2: #{page2_events.size}, page3: #{page3_events.size}), API: #{remaining}, reset: #{reset}"

          if new_events.size >= (PAGE_LIMIT * 3)
            @log.warn "Potentially missed records - got #{new_events.size} new events (at GitHub's 300 event limit)"
          end

          StatHat.new.ez_count('Github Events', new_events.size)

          EM.add_timer(0.2, &process)
        end

      rescue Exception => e
        @log.error "Failed to process response"
        @log.error "Response page 1: #{req1.response}"
        @log.error "Response headers: #{req1.response_header}"
        @log.error "Processing exception: #{e}, #{e.backtrace.first(5)}"
        EM.add_timer(0.75, &process)
      end
    end

    req1.errback do
      @log.error "Error fetching page 1: #{req1.response_header.status}, \
                  header: #{req1.response_header}, \
                  response: #{req1.response}"

      EM.add_timer(0.75, &process)
    end
  end

  process.call
end
