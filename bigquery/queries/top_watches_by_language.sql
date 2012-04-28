/* watches for a specific language + date range */
SELECT repository_name, count(repository_name) as watches, repository_description, repository_url
FROM github.events
WHERE type="WatchEvent"
	AND repository_language="Ruby"
	AND PARSE_UTC_USEC(created_at) >= PARSE_UTC_USEC('2012-04-01 00:00:00')
GROUP BY repository_name, repository_description, repository_url
ORDER BY watches DESC