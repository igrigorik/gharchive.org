# GitHub Archive

[http://www.githubarchive.org]()

Open-source developers all over the world are working on millions of projects: writing code & documentation, fixing & submitting bugs, and so forth. GitHub Archive is a project to **record** the public GitHub timeline, **archive it**, and **make it easily accessible for** further analysis.

![Stats](http://www.stathat.com/graphs/02/d4/311b14f71eacc7d422c8a113390c_overlay.png)

----

GitHub provides [18 event types](http://developer.github.com/v3/events/types/), which range from new commits and fork events, to opening new tickets, commenting, and adding members to a project. The activity is aggregated in hourly archives, which you can access with any HTTP client:

<table>
<thead>
  <tr>
    <th>Query</th>
    <th>Command</th>
  </tr>
</thead>
<tbody>
  <tr>
    <td>Activity for March 11, 2012 at 3PM PST</td>
    <td><code>wget http://data.githubarchive.org/2012-03-11-15.json.gz</code></td>
  </tr>
  <tr>
    <td>Activity for March 11, 2012</td>
    <td><code>wget http://data.githubarchive.org/2012-03-11-{0..23}.json.gz</code></td>
  </tr>
  <tr>
    <td>Activity for March 2012</td>
    <td><code>wget http://data.githubarchive.org/2012-03-{01..31}-{0..23}.json.gz</code></td>
  </tr>
</tbody>
</table>

__Note: timeline data is available starting March 11, 2012.__

----

Each archive contains a stream of JSON encoded GitHub events ([sample](https://gist.github.com/2017462)), which you can process in any language. Ruby example:

```ruby
require 'open-uri'
require 'zlib'
require 'yajl'

gz = open('http://data.githubarchive.org/2012-03-11-12.json.gz')
js = Zlib::GzipReader.new(gz).read

Yajl::Parser.parse(js) do |event|
  print event
end
```

### License

(MIT License) - Copyright (c) 2012 Ilya Grigorik
