require 'tempfile'
require 'time'
require 'zlib'
require 'yajl'
require 'csv'

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

input = ARGV.shift
if input.nil?
  puts "No input file specified"
  exit(1)
end

schema = Yajl::Parser.parse(open('schema.js').read)
headers = schema['configuration']['load']['schema']['fields'].map {|f| f['name']}

begin
  tmp = Tempfile.new("bigquery-#{input}")
  js  = Zlib::GzipReader.new(open(input)).read

  Yajl::Parser.parse(js) do |event|
  	r = CSV::Row.new(headers, [])
  	flatmap({}, event).each do |k,v|
      v = (Time.parse(v).utc.strftime('%Y-%m-%d %T') rescue '') if k =~ /_at$/
      if r.include? k
        r[k] = v
      else
        puts "Unknown field: #{k}, value: #{v}"
      end
    end
  	tmp << r.to_s
  end

  puts "Uploading file to BigQuery"
  puts system('python upload.py ' + tmp.path)

  puts "\nDone.\n"

ensure
  tmp.close
  tmp.unlink
end