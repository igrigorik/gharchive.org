require 'log4r'
require 'yajl'

require 'em-http'
require 'em-http/middleware/json_response'
require 'em-stathat'

include EM

##
## Setup
##

#HttpRequest.use Middleware::JSONResponse
StatHat.config do |c|
  c.ukey  = ENV['STATHATKEY']
  c.email = 'ilya@igvita.com'
end

@log = Log4r::Logger.new('github')
@log.add(Log4r::StdoutOutputter.new('console', {
  :formatter => Log4r::PatternFormatter.new(:pattern => "[#{Process.pid}:%l] %d :: %m")
}))

@latest = []

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

  @file_generator = lambda { File.new("data/#{Time.now.strftime('%Y-%m-%d-%-k')}.json.current", "a+") }
  @file = @file_generator.call

  # set the hourly timer to fire on the hour
  EM.add_timer(60*60 - (Time.now.to_i % (60*60))) do
    rotate = Proc.new do
      @log.info "Rotating file: #{@file.to_path}"
      @file.close

      File.rename(@file.to_path, @file.to_path.chomp('.current'))
      @file = @file_generator.call
    end

    rotate.call

    # swap the file every 60 minutes after that
    EM.add_periodic_timer(60*60, &rotate)
  end

  process = Proc.new do
      req = HttpRequest.new("https://github.com/timeline.json").get({
      :head => {
        'user-agent' => 'archiver.io'
      }
    })

    req.callback do
      begin
        latest = Yajl::Parser.parse(req.response)
        urls = latest.collect {|e| e['url']}
        new_events = latest.reject {|e| @latest.include? e['url']}

        @latest = urls
        new_events.each do |event|
          @file.write(Yajl::Encoder.encode(event))
        end

        @log.info "Found #{new_events.size} new events"
        StatHat.new.ez_count('Github Events', new_events.size)

        if new_events.size >= 25
          EM.add_timer(1.5, &process)
        end

      rescue Exception => e
        @log.error "Processing exception: #{e}, #{e.backtrace.first(5)}"
        @log.error "Response: #{req.response_header}, #{req.response}"
      end
    end

    req.errback do
      @log.error "Error: #{req.response_header.status}, header: #{req.response_header}, response: #{req.response}"
    end
  end

  EM.add_periodic_timer(6, &process)
end
