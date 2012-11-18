require 'hominid'
require 'json'
require 'erb'

yesterday = (Time.now - 60*60*24).strftime("%Y-%m-%d")
template = ERB.new IO.read('template.html')


top_new_repos = <<-SQL
SELECT repository_name, repository_language, repository_description, COUNT(repository_name) as cnt, repository_url
FROM github.timeline
WHERE type="WatchEvent"
  AND PARSE_UTC_USEC(created_at) >= PARSE_UTC_USEC("#{yesterday} 20:00:00")
        AND repository_url IN (
      SELECT repository_url
      FROM github.timeline
      WHERE type="CreateEvent"
              AND PARSE_UTC_USEC(repository_created_at) >= PARSE_UTC_USEC('#{yesterday} 20:00:00')
              AND repository_fork = "false"
              AND payload_ref_type = "repository"
      GROUP BY repository_url
    )
GROUP BY repository_name, repository_language, repository_description, repository_url
HAVING cnt >= 5
ORDER BY cnt DESC
LIMIT 25
SQL

top_watched_repos = <<-SQL
SELECT repository_name, repository_language, repository_description, COUNT(repository_name) as cnt, repository_url
FROM github.timeline
WHERE type='WatchEvent'
  AND PARSE_UTC_USEC(created_at) >= PARSE_UTC_USEC('#{yesterday} 20:00:00')
GROUP BY repository_name, repository_language, repository_description, repository_url
HAVING cnt >= 10
ORDER BY cnt DESC
LIMIT 25
SQL


def run_query(q)
  q = q.gsub(/\/\*.*/,'').gsub(/'/m,'"').strip
  JSON.parse(`/usr/local/bin/bq -q --format=prettyjson --credential_file /home/archiver/githubarchive/bigquery/.bigquery.v2.token query '#{q}'`)
end

def send_email(title, html)
  h = Hominid::API.new(ENV['HOMINID_KEY'])
  c = h.campaign_create('regular', {
    :list_id => ENV['HOMINID_LIST'],
    :subject => title,
    :from_email => 'ilya+gha@igvita.com',
    :from_name => 'GitHub Archive'
   },{
    :html => html.to_s.encode('ascii', 'binary', :invalid => :replace, :undef => :replace, :replace => '')
  })

  h.campaign_send_now c
end

today = Time.now.strftime('%b %d')
topwatched = run_query top_watched_repos
topnew = run_query top_new_repos
output = template.result(binding)

puts "Sending top new & watched: " + send_email("GitHub Archive: Top new & watched repos - #{today}", output).to_s
