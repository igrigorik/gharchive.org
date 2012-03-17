# GitHub Archive

[http://www.githubarchive.org]()

Open-source developers all over the world are working on millions of projects: writing code & documentation, fixing & submitting bugs, and so forth. GitHub Archive is a project to **record** the public GitHub timeline, **archive it**, and **make it easily accessible for** further analysis.

![Stats](http://www.stathat.com/graphs/02/d4/311b14f71eacc7d422c8a113390c_overlay.png)

----

GitHub provides 17 event types, which range from new commits and fork events, to opening new tickets, commenting, and adding members to a project. The activity is aggregated in hourly archives, which you can access with any HTTP client:

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
    <td><code>wget http://data.githubarchive.org/2012-03-11-{0..24}.json.gz</code></td>
  </tr>
  <tr>
    <td>Activity for March 2012</td>
    <td><code>wget http://data.githubarchive.org/2012-03-{0..30}-{0..24}.json.gz</code></td>
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

----

<table class="table table-striped">
<thead>
  <tr>
    <th>Projects using GitHub Archive data</th>
    <th>Link</th>
  </tr>
</thead>
<tbody>
  <tr>
    <td><i>your project here</i></td>
    <td><i><a href="https://github.com/igrigorik/githubarchive.org">fork and update</a></i></td>
  </tr>
</tbody>
</table>

### License

(MIT License) - Copyright (c) 2012 Ilya Grigorik
