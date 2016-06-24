require 'optparse'
require 'time'
require 'zlib'
require 'yajl'

require_relative 'transformer'

ARGV << '--help' if ARGV.empty?

options = {schema: 'schema.js', compress: true}
OptionParser.new do |opts|
  opts.banner = "Usage: upload.rb [options]"

  opts.on("-i", "--input FILE", "input filename") do |v|
    options[:input] = v
  end

  opts.on("-o", "--output FILE", "output filename") do |v|
    options[:output] = v
  end

  opts.on("-s", "--schema FILE", "schema file (default: schema.js)") do |v|
    options[:schema] = v
  end

  opts.on("-c", "--[no-]compress", "compress output") do |v|
    options[:compress] = v
  end
end.parse!

#
# Map GitHub events to a JSON schema
# - static header is mapped to BQ fields
# - dynamic payload is encoded as a STRING
#

start = Time.now

begin
  options[:output] ||= options[:input] + "-out.json"
  options[:output] += '.gz' if options[:compress]

  cnt, skip = 0, 0
  out = File.new(options[:output], "w")
  out = Zlib::GzipWriter.new(out) if options[:compress]
  js  = if File.extname(options[:input]) == '.gz'
    Zlib::GzipReader.new(open(options[:input])).read
  else
    open(options[:input])
  end

  Yajl::Parser.parse(js) do |event|
    transformer = EventTransform.new(event)
    transformer.process
    tranformed_event = transformer.parsed_event

    encoded = Yajl::Encoder.encode(tranformed_event)

    # https://cloud.google.com/bigquery/preparing-data-for-bigquery#dataformats
    if encoded.size > 2*1024*1024
      puts "Encoded size: #{encoded.size} exceeds 2MB row limit, skipping."
      skip += 1
    else
      out.puts encoded
      cnt += 1
    end
  end

  out.close
  puts "Transformed #{options[:input]}: saved #{cnt}, skipped #{skip}. Runtime: #{(Time.now - start).round} seconds."
  puts "\tUploading data to BigQuery..."

  # upload the data to BigQuery
  table = "day." + Time.parse(options[:input]).strftime("%Y%m%d")
  newtable = `bq show #{table}`.downcase.include? 'error'

  status = system(
        "bq load --source_format NEWLINE_DELIMITED_JSON " +
        "#{table} #{options[:output]} " +
        "#{options[:schema] if newtable}"
      )

  if !status
    puts "\t BQ upload failed"
  else
    puts "\t BQ upload finished"
  end

ensure
  File.unlink(options[:output])
end
