# Google BigQuery + Github Archive

[Google BigQuery](https://developers.google.com/bigquery/) is a web service that lets you do interactive analysis of massive datasets—up to billions of rows.

The Github Activity stream is automatically uploaded to BigQuery sevice to enable interactive analysis.

## Sample Queries

```sql
/* count the number of events by type */
SELECT type, count(type) as total FROM github.events group by type order by total desc;

/* find the most watched repositories */
select repository_name, count(repository_name) as new_watchers from github.events where type = "WatchEvent" group by repository_name order by new_watchers desc;

```