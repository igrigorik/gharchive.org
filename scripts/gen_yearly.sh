#!/bin/bash

yearstart=$1
yearend=$2

now=`date +"%Y-%m-%d" -d "01/01/$yearstart"`
end=`date +"%Y-%m-%d" -d "01/01/$yearend"`

while [ "$now" != "$end" ];
do
  echo "Processing $now"
  dst=`date +"%Y" -d "$now"`;
  tst=`date +"%Y-%m" -d "$now"`;
  tnd=`date +"%Y-%m" -d "$now + 1 year"`;

  echo "\t $dst <- $tst - $tnd"
  query="SELECT * FROM (TABLE_DATE_RANGE([day.], TIMESTAMP('$tst-01'), TIMESTAMP('$tnd-01')))"
  echo $(bq query --allow_large_results --noflatten_results --replace --destination_table=year.$dst "$query")

  now=`date +"%Y-%m-%d" -d "$now + 1 year"`;
done

#SELECT
# *
#FROM
#  `githubarchive.month.*`
#WHERE
#  _TABLE_SUFFIX BETWEEN '20180101' AND '20190101'
