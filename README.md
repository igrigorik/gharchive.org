# GitHub Archive

[http://www.githubarchive.org](http://www.githubarchive.org/)

Open-source developers all over the world are working on millions of projects: writing code & documentation, fixing & submitting bugs, and so forth. GitHub Archive is a project to **record** the public GitHub timeline, **archive it**, and **make it easily accessible for** further analysis.

![Stats](http://www.stathat.com//graphs/39/33/0b63991416f6b680e69f017a2c12.png?1340405820)

----

Looking for the [daily top new & watched repository](http://us5.campaign-archive2.com/home/?u=439aa16a39e4b10e0b65ff2ef&id=0b82fec5c2) reports? [Sign up here](http://githubarchive.us5.list-manage.com/subscribe?u=439aa16a39e4b10e0b65ff2ef&id=0b82fec5c2).

----

GitHub provides [23 event types](http://developer.github.com/v3/activity/events/types/), which range from new commits and fork events, to opening new tickets, commenting, and adding members to a project. The activity is aggregated in hourly archives, which you can access with any HTTP client:

<table>
<thead>
  <tr>
    <th>Query</th>
    <th>Command</th>
  </tr>
</thead>
<tbody>
  <tr>
    <td>Activity for April 11, 2012 at 3PM PST</td>
    <td><code>wget http://data.githubarchive.org/2012-04-11-15.json.gz</code></td>
  </tr>
  <tr>
    <td>Activity for April 11, 2012</td>
    <td><code>wget http://data.githubarchive.org/2012-04-11-{0..23}.json.gz</code></td>
  </tr>
  <tr>
    <td>Activity for April 2012</td>
    <td><code>wget http://data.githubarchive.org/2012-04-{01..30}-{0..23}.json.gz</code></td>
  </tr>
</tbody>
</table>

__Note: timeline data is available starting February 12, 2011.__

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
__Note: [example script to import data into SQLite db](https://gist.github.com/2426614)__

----

GitHub Archive dataset is also available via [Google BigQuery](https://developers.google.com/bigquery/). The JSON data is [normalized](https://github.com/igrigorik/githubarchive.org/blob/master/bigquery/schema.js) and is updated every hour, allowing you to run [arbitrary queries](https://developers.google.com/bigquery/docs/query-reference) and analysis over the entire dataset in seconds. To get started, login into the [BigQuery console](https://bigquery.cloud.google.com), and add the project (name: "*githubarchive*"), or take a look at the 03/11..05/11 snapshot of the data under "publicdata:samples":

![BigQuery](http://www.githubarchive.org/assets/img/bigquery-directions.png)

An example query, for more check the [repository readme](https://github.com/igrigorik/githubarchive.org/tree/master/bigquery):

```sql
/* top 100 repos for Ruby by number of pushes */
SELECT repository_name, count(repository_name) as pushes, repository_description, repository_url
FROM [githubarchive:github.timeline]
WHERE type="PushEvent"
    AND repository_language="Ruby"
    AND PARSE_UTC_USEC(created_at) >= PARSE_UTC_USEC('2012-04-01 00:00:00')
GROUP BY repository_name, repository_description, repository_url
ORDER BY pushes DESC
LIMIT 100
```

### License

(MIT License) - Copyright (c) 2012 Ilya Grigorik
