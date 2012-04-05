require 'optparse'
require 'time'
require 'zlib'
require 'yajl'
require 'csv'

options = {schema: 'schema.js', verbose: false}
OptionParser.new do |opts|
  opts.banner = "Usage: flatten.rb [options]"

  opts.on("-i", "--input FILE", "input filename") do |v|
    options[:input] = v
  end

  opts.on("-o", "--output FILE", "output filename") do |v|
    options[:output] = v
  end

  opts.on("-s", "--schema FILE", "schema file") do |v|
    options[:schema] = v
  end

  opts.on("-v", "--verbose", "verbose log") do |v|
    options[:verbose] = true
  end
end.parse!

#
# Map GitHub JSON schema to flat CSV space based
# on provided Big Query column schema
#

def flatmap(h, e, prefix = '')
  e.each do |k,v|
    if v.is_a?(Hash)
      flatmap(h, v, prefix+k+"_")
    else
      h[prefix+k] = v unless v.is_a? Array
    end
  end
  h
end

start = Time.now
schema = Yajl::Parser.parse(open(options[:schema]).read)
headers = schema['configuration']['load']['schema']['fields'].map {|f| f['name']}

begin
  out = File.new(options[:output] || (options[:input] + "-out.csv"), "w")
  js  = Zlib::GzipReader.new(open(options[:input])).read
  cnt = 0

  Yajl::Parser.parse(js) do |event|
    r = CSV::Row.new(headers, [])
    flatmap({}, event).each do |k,v|
      v = (Time.parse(v).utc.strftime('%Y-%m-%d %T') rescue '') if k =~ /_at$/
      if r.include? k
        r[k] = v
      else
        puts "Unknown field: #{k}, value: #{v}" if options[:verbose]
      end
    end

    cnt += 1
    out << r.to_s
  end

  puts "Processed #{options[:input]}: #{cnt} rows in #{(Time.now - start).round} seconds"
ensure
  out.close
end
