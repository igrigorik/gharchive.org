require 'log4r'
require 'yajl'
require 'em-http'
require 'em-stathat'

include EM

##
## Setup
##

StatHat.config do |c|
  c.ukey  = ENV['STATHATKEY']
  c.email = 'ilya@igvita.com'
end

@log = Log4r::Logger.new('github')
@log.add(Log4r::StdoutOutputter.new('console', {
  :formatter => Log4r::PatternFormatter.new(:pattern => "[#{Process.pid}:%l] %d :: %m")
}))

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

  process = Proc.new do
      req = HttpRequest.new("https://api.github.com/events").get({
      :head => {
        'user-agent' => 'githubarchive.org',
        'Authorization' => 'token ' + ENV['GITHUB_TOKEN']
      }
    })

    req.callback do
      begin
        latest = Yajl::Parser.parse(req.response)
        urls = latest.collect(&@latest_key)
        new_events = latest.reject {|e| @latest.include? @latest_key.call(e)}

        @latest = urls
        new_events.reverse.each do |event|
          timestamp = Time.parse(event['created_at']).strftime('%Y-%m-%d-%-k')
          archive = "data/#{timestamp}.json.current"

          if @file.nil? || (archive != @file.to_path)
            unless @file.nil?
              @log.info "Rotating archive. Old: #{@file.to_path}, New: #{archive}"
              @file.close
              File.rename(@file.to_path, @file.to_path.chomp('.current'))
            end

            @file = File.new(archive, "a+")
          end

          @file.puts(Yajl::Encoder.encode(event))
        end

        @log.info "Found #{new_events.size} new events"
        StatHat.new.ez_count('Github Events', new_events.size)

        if new_events.size >= 15
          EM.add_timer(1.0, &process)
        end

      rescue Exception => e
        @log.error "Processing exception: #{e}, #{e.backtrace.first(5)}"
        @log.error "Response: #{req.response_header}, #{req.response}"
      end
    end

    req.errback do
      @log.error "Error: #{req.response_header.status}, \
                  header: #{req.response_header}, \
                  response: #{req.response}"
    end
  end

  EM.add_periodic_timer(2.5, &process)
end
