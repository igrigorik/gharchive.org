require 'optparse'
require 'time'

options = {verbose: false, sync: true}
OptionParser.new do |opts|
  opts.banner = "Usage: sync.rb [options]"

  opts.on("-f", "--file FILE", "input filename") do |v|
    options[:file] = v
  end

  opts.on("-s", "--[no-]sync", "sync upload") do |v|
    options[:sync] = v
  end

  opts.on("-v", "--verbose", "verbose log") do |v|
    options[:verbose] = v
  end
end.parse!

raise OptionParser::MissingArgument if options[:file].nil?

# transform the file to the (flat) BigQuery CSV schema
r = system("ruby transform.rb -i #{options[:file]} -o /tmp/bq.csv #{'-v' if options[:verbose]}")
exit(1) if !r

# upload the data to BigQuery
puts system(`which bq`.chomp + " #{'--nosync' if !options[:sync]} " +
			"#{'--apilog true' if options[:verbose]} " +
			"load github.events /tmp/bq.csv.gz")

puts system("rm /tmp/bq.csv.gz")