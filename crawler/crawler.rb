require 'log4r'
require 'yajl'
require 'digest'
require 'em-http'
require 'em-stathat'

require_relative "obfuscate.rb"

include EM

##
## Setup
##

PAGE_LIMIT = 100

StatHat.config do |c|
  c.ukey  = ENV['STATHATKEY']
  c.email = 'xxx'  ## must specify here?
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

  github_tokens = [ENV['GITHUB_TOKEN']]
  current_token_index = 0

  process = Proc.new do
      github_token = github_tokens[current_token_index]
      current_token_index = (current_token_index + 1) % github_tokens.length
      @log.info "using github token #{github_token}"
      req_url = "https://api.github.com/events?per_page=#{PAGE_LIMIT}"
      req = HttpRequest.new(req_url, {
        :inactivity_timeout => 5,
        :connect_timeout => 5
      }).get({
      :head => {
        'user-agent' => 'gharchive.org',
        'Authorization' => 'token ' + github_token
      }
    })

    req.callback do
      begin
        latest = Yajl::Parser.parse(req.response)
        urls = latest.collect(&@latest_key)
        new_events = latest.reject {|e| @latest.include? @latest_key.call(e)}

        @latest = urls
        new_events.sort_by {|e| [Time.parse(e['created_at']), e['id']] }.each do |event|
          timestamp = Time.parse(event['created_at']).strftime('%Y-%m-%d-%-k')
          archive = "data/#{timestamp}.json"

          if @file.nil? || (archive != @file.to_path)
            if !@file.nil?
              @log.info "Rotating archive. Current: #{@file.to_path}, New: #{archive}"
              @file.close
            end

            @file = File.new(archive, "a+")
          end

          @file.puts(Yajl::Encoder.encode(Obfuscate.email(event)))
        end

        remaining = req.response_header.raw['X-RateLimit-Remaining']
        reset = Time.at(req.response_header.raw['X-RateLimit-Reset'].to_i)
        @log.info "Found #{new_events.size} new events: #{new_events.collect(&@latest_key)}, API: #{remaining}, reset: #{reset}"

        ## TODO: how to handle missing events? - lower request timer?
        @exceed_log_file = File.new("event_exceed.txt", "a+")
        if new_events.size >= PAGE_LIMIT
          @log.info "================== Missed records... =================="
          ## write to a file, test for 1 hour once
          @exceed_log_file.puts(Time.now)
        end

        StatHat.new.ez_count('Github Events', new_events.size)

      rescue Exception => e
        @log.error "Failed to process response"
        @log.error "Response: #{req.response}"
        @log.error "Response headers: #{req.response_header}"
        @log.error "Processing exception: #{e}, #{e.backtrace.first(5)}"
      ensure
        # 0.75s is for token rate limit?
        EM.add_timer(0.2, &process)
      end
    end

    req.errback do
      @log.error "Error: #{req.response_header.status}, \
                  header: #{req.response_header}, \
                  response: #{req.response}"

      EM.add_timer(0.2, &process)
    end
  end

  process.call
end