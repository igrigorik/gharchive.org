#!/usr/bin/python
#
# BigQuery documentation:
# https://developers.google.com/bigquery/docs/developers_guide#importingatable
#

import httplib2
import sys

from oauth2client.file import Storage
from oauth2client.client import AccessTokenRefreshError
from apiclient.errors import HttpError

def loadTable(http, filename, projectId):
  f = open('schema.js', 'r')
  schema = f.read()

  newresource = ('--xxx\n' +
            'Content-Type: application/json; charset=UTF-8\n' + '\n' +
            schema + '\n' +
            '--xxx\n' +
            'Content-Type: application/octet-stream\n' +
            '\n')

  f = open(filename, 'r')
  newresource += f.read() # Append data from the specified file to the request body
  newresource += ('--xxx--\n') # Signify the end of the body

  url = "https://www.googleapis.com/upload/bigquery/v2/projects/" + projectId + "/jobs"
  headers = {'Content-Type': 'multipart/related; boundary=xxx'}

  resp, content = http.request(url, method="POST", body=newresource, headers=headers)
  print str(resp) + "\n"
  print content

def main(argv):
  storage = Storage('bigquery.auth')
  credentials = storage.get()

  http = httplib2.Http()
  http = credentials.authorize(http)

  loadTable(http, argv[1], '743956506022')

if __name__ == '__main__':
  main(sys.argv)
