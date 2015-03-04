# GitHub Archive

[http://www.githubarchive.org](http://www.githubarchive.org/)

Open-source developers all over the world are working on millions of projects: writing code & documentation, fixing & submitting bugs, and so forth. GitHub Archive is a project to **record** the public GitHub timeline, **archive it**, and **make it easily accessible for** further analysis.

![Stats](http://www.stathat.com//graphs/39/33/0b63991416f6b680e69f017a2c12.png?1340405820)

GitHub provides [20+ event types](http://developer.github.com/v3/activity/events/types/), which range from new commits and fork events, to opening new tickets, commenting, and adding members to a project. These events are  aggregated into hourly archives, which you can access with any HTTP client:

<table>
<thead>
  <tr>
    <th>Query</th>
    <th>Command</th>
  </tr>
</thead>
<tbody>
  <tr>
    <td>Activity for Jan 1, 2015 at 3PM UTC</td>
    <td><code>wget http://data.githubarchive.org/2015-01-01-15.json.gz</code></td>
  </tr>
  <tr>
    <td>Activity for Jan 1, 2015</td>
    <td><code>wget http://data.githubarchive.org/2015-01-01-{0..23}.json.gz</code></td>
  </tr>
  <tr>
    <td>Activity for January 2015</td>
    <td><code>wget http://data.githubarchive.org/2015-01-{01..30}-{0..23}.json.gz</code></td>
  </tr>
</tbody>
</table>

Each archive contains JSON encoded events as reported by the GitHub API. You can download the raw data and apply own processing to it - e.g. write a custom aggregation script, import it into a database, and so on! An example Ruby script to download and iterate over a single archive:

```ruby
require 'open-uri'
require 'zlib'
require 'yajl'

gz = open('http://data.githubarchive.org/2015-01-01-12.json.gz')
js = Zlib::GzipReader.new(gz).read

Yajl::Parser.parse(js) do |event|
  print event
end
```

* Activity archives are available starting 2/12/2011.
* Activity archives for dates between 2/12/2011-12/31/2014 was recorded from the (now deprecated) Timeline API.
* Activity archives for dates starting 1/1/2015 is recorded from the Events API.


### Analyzing event data with BigQuery 

The entire GitHub Archive is also available as a public dataset on [Google BigQuery](https://developers.google.com/bigquery/): the dataset is automatically updated every hour and enables you to run [arbitrary SQL-like queries](https://developers.google.com/bigquery/docs/query-reference) over the entire dataset in seconds - i.e. no need to download or process any data on your own. To get started: 

1. If you don't already have a Google project...
 * [Login into the Google Developer Console](https://console.developers.google.com/)
 * [Create a project](https://developers.google.com/console/help/#creatingdeletingprojects) and [activate the BigQuery API](https://developers.google.com/console/help/#activatingapis)
2. Open public dataset: https://bigquery.cloud.google.com/project/githubarchive
3. Execute your first example query...

```sql
/* count of issues opened, closed, and reopened between 1/1/2015 and 2/1/2015 */
SELECT event as issue_status, COUNT(*) as cnt FROM (
  SELECT type, repo.name, actor.login,
    JSON_EXTRACT(payload, '$.action') as event, 
  FROM (TABLE_DATE_RANGE(github.events_, 
    TIMESTAMP('2015-01-01'), 
    TIMESTAMP('2015-02-01')
  )) 
  WHERE type = 'IssuesEvent'
)
GROUP by issue_status;
```

Note that the public dataset contains several types of tables: 

* `2011`, `2012`, `2013`, and `2014` tables contain activities for each respective year
  * The schema is in a "flattened" format where each field is mapped into a distinct column
  * The schema is the same between all years
* `events_YYYYMMDD` tables contain daily activity starting from 1/1/2015
  * The schema contains distinct columns for common activity fields (see "[same response format](https://developer.github.com/v3/activity/events/)"), plus a `payload` string field which contains the JSON encoded activity description. The format of the `payload` is different for each type and may be updated by GitHub at any point, hence it is kept as a string value in BigQuery. However, you **can** extract particular fields from the `payload` using the provided [JSON functions](https://cloud.google.com/bigquery/query-reference#jsonfunctions) - e.g. see query example above with `JSON_EXTRACT()`.

Starting 1/1/2015 the data is split into daily tables to allow for more efficient processing. Note that you can still run queries that span multiple tables using a [table wildcard](https://cloud.google.com/bigquery/query-reference#tablewildcardfunctions) - e.g. see example above with `TABLE_DATE_RANGE()`. 

_Note: you get [1 TB of data processed per month free of charge](https://cloud.google.com/bigquery/pricing#queries), use it wisely!_

### Research, visualizations, talks... 

* GitHub Data Challenge: [2012](https://github.com/blog/1162-github-data-challenge-winners), [2013](https://github.com/blog/1544-data-challenge-ii-results), and [2014 winners](https://github.com/blog/1892-third-annual-data-challenge-winners).
* [Analyzing Millions of GitHub Commits (Strata talk)](https://www.youtube.com/watch?v=U_LNo_cSc70)
* [GitHut](http://githut.info/) is an attempt to visualize and explore the complexity of the universe of programming languages used across the repositories hosted on GitHub.
* [Octoboard](http://octoboard.com/) is a GitHub activity dashboard.
* [Who speaks what on GitHub?](http://danielvdende.com/gdc2014/) Three visualizations provide insight into the language skills of users on GitHub.
* [GitHub in 2013](http://blog.coderstats.net/github/2013/event-types/) is a brief visual overview of GitHub event types in 2013.
* [Exploring Expressions of Emotions in GitHub Commit Messages](http://geeksta.net/geeklog/exploring-expressions-emotions-github-commit-messages/)
* [Language Use on GitHub](http://datahackermd.com/2013/language-use-on-github/) visualization of the rank correlation between languages.
* [The Top 11 Hottest GitHub Projects Right Now](http://www.fastcolabs.com/3015178/the-top-10-hottest-github-projects-right-now?partner=rss)
* [Ask GitHub](http://askgithub.com) - search latest GitHub timeline
* [Commit Logs From Last Night](http://www.commitlogsfromlastnight.com/)

_P.S. Have a cool project? Update the readme, send a pull request!_
