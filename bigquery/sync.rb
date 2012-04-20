require 'optparse'
require 'time'
require 'json'

ARGV << '--help' if ARGV.empty?

options = {verbose: false, sync: true, token: '.bigquery.v2.token'}
OptionParser.new do |opts|
  opts.banner = "Usage: sync.rb [options]"

  opts.on("-f", "--file FILE", "input filename") do |v|
    options[:file] = v
  end

  opts.on("-s", "--[no-]sync", "sync upload") do |v|
    options[:sync] = v
  end

  opts.on("-t", "--token FILE", "token filename") do |v|
    options[:token] = v
  end

  opts.on("-v", "--verbose", "verbose log") do |v|
    options[:verbose] = v
  end
end.parse!

raise OptionParser::MissingArgument if options[:file].nil?

# transform the file to the (flat) BigQuery CSV schema
r = system("ruby transform.rb -i #{options[:file]} -o /tmp/bq.csv #{'-v' if options[:verbose]}")
exit(1) if !r

# expire current oauth token
j = JSON.parse(IO.read(options[:token]))
j['access_token'] = 'expired'

# force refresh of the current token
File.open(options[:token], 'w') {|f| f.write JSON.generate(j)}
system("/usr/local/bin/bq --credential_file /home/archiver/githubarchive/bigquery/.bigquery.v2.token ls")

# upload the data to BigQuery
system("/usr/local/bin/bq #{'--nosync' if !options[:sync]} " +
       "#{'--apilog true' if options[:verbose]} " +
       "--credential_file /home/archiver/githubarchive/bigquery/.bigquery.v2.token " +
       "load github.events /tmp/bq.csv.gz")

File.unlink("/tmp/bq.csv.gz")
File.unlink(options[:file])
