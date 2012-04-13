# Google BigQuery + Github Archive

[Google BigQuery](https://developers.google.com/bigquery/) is a web service that lets you do interactive analysis of massive datasets—up to billions of rows.

The Github Activity stream is automatically uploaded to BigQuery sevice to enable interactive analysis.

## Sample Queries

```sql
/* count the number of events by type */
SELECT type, count(type) as total
	FROM github.events
	GROUP BY type
	ORDER BY total desc;

/* find the most watched repositories */
SELECT repository_name, count(repository_name) as new_watchers
	FROM github.events
	WHERE type = "WatchEvent"
	GROUP BY repository_name
	ORDER BY new_watchers desc;
```

For full schema of available fields to select, order, and group by, see schema.js.

## Manually loading the data

If you want to load the archive data into your own BigQuery project:

```bash
$> wget http://data.githubarchive.org/2012-03-11-15.json.gz
$> ruby transform.rb -i 2012-03-11-15.json.gz
$> python bq.py --apilog true load github.events 2012-03-11-15.json.gz-out.csv.gz schema.js
```
