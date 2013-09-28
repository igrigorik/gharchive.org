# encoding: UTF-8

require 'optparse'
require 'time'
require 'zlib'
require 'yajl'
require 'csv'

$: << '.'
require 'remap.rb'

ARGV << '--help' if ARGV.empty?

options = {schema: 'schema.js', verbose: false, compress: true}
OptionParser.new do |opts|
  opts.banner = "Usage: flatten.rb [options]"

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

  opts.on("-v", "--verbose", "verbose log (default: false)") do |v|
    options[:verbose] = v
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
      if not v.is_a? Array
        if v.is_a? String
          v.force_encoding('binary')
          v = v.encode('UTF-8', :invalid => :replace, :undef => :replace).split.join(' ')
          v = v[0,10000] + ' ...' if v.size > 10000
        end

        h[prefix+k] = v
      end
    end
  end
  h
end

def save(row, event, opt)
  flatmap({}, event).each do |k,v|
    v = (Time.parse(v).utc.strftime('%Y-%m-%d %T') rescue '') if k =~ /_at$/
    v.clean! if v.is_a? String

    if row.include?(k)
      row[k] = v
    else
      nk = k.remap
      if row.include?(nk)
        puts "Remapped #{k} => #{nk}, value: #{v}" if opt[:verbose]
        row[nk] = v
      else
        puts "Unknown field: #{k}, value: #{v}" if opt[:verbose] && !IGNORED.include?(k)
      end
    end
  end
end

start = Time.now
schema = Yajl::Parser.parse(open(options[:schema]).read)
headers = schema.map {|f| f['name']}

begin
  options[:output] ||= options[:input] + "-out.csv"
  options[:output] += '.gz' if options[:compress]

  out = File.new(options[:output], "w")
  out = Zlib::GzipWriter.new(out) if options[:compress]
  js  = Zlib::GzipReader.new(open(options[:input])).read
  cnt = 0

  Yajl::Parser.parse(js) do |event|
    r = CSV::Row.new(headers, [])

    case event['type']
    when 'PushEvent'
      num = event['payload'].delete 'size'
      commits = event['payload'].delete 'shas'
      commits ||= []

      commits.each do |commit|
        id, email, msg, name, flag = *commit
        event['payload'].merge!({
          'commit' => {
            'id' => id, 'email' => email, 'msg' => msg,
            'name' => name, 'flag' => flag
          }
        })

        save(r, event, options)
      end
    when 'GollumEvent'
      pages = event['payload'].delete 'pages'
      pages ||= []

      pages.each do |page|
        page['summary'] = page['summary'] if page['summary']
        event['payload'].merge!({'page' => page})
        save(r, event, options)
      end
    else
      save(r, event, options)
    end

    raise "Record <> schema mismatch: #{r.size}, #{schema.size}. Exiting." if r.size != schema.size

    cnt += 1
    out.write r.to_s
  end

  puts "Processed #{options[:input]}: #{cnt} rows in #{(Time.now - start).round} seconds"
ensure
  out.close
end
