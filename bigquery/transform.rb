# encoding: UTF-8

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
headers = schema.map {|f| f['name']}

begin
  out = File.new(options[:output] || (options[:input] + "-out.csv.gz"), "w")
  ogz = Zlib::GzipWriter.new(out)
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

    raise "Record <> schema mismatch: #{r.size}, #{schema.size}. Exiting." if r.size != schema.size

    cnt += 1
    ogz.write r.to_s.encode('ascii', 'binary', :invalid => :replace, :undef => :replace, :replace => '')
  end

  puts "Processed #{options[:input]}: #{cnt} rows in #{(Time.now - start).round} seconds"
ensure
  ogz.close
end
