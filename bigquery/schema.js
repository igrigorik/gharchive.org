[
  {
    "name": "type",
    "type": "STRING",
    "description": "https://developer.github.com/v3/activity/events/types/"
  },
  {
    "name": "public",
    "type": "BOOLEAN",
    "description": "Always true for this dataset since only public activity is recorded."
  },
  {
    "name": "payload",
    "type": "STRING",
    "description": "Event payload in JSON format"
  },
  {
    "name": "repo",
    "type": "RECORD",
    "description": "Repository associated with the event",
    "fields": [
      {
        "name": "id",
        "type": "INTEGER",
        "description": "Numeric ID of the GitHub repository"
      },
      {
        "name": "name",
        "type": "STRING",
        "description": "Repository name"
      },
      {
        "name": "url",
        "type": "STRING",
        "description": "Repository URL"
      }
    ]
  },
  {
    "name": "actor",
    "type": "RECORD",
    "description": "Actor generating the event",
    "fields": [
      {
        "name": "id",
        "type": "INTEGER",
        "description": "Numeric ID of the GitHub actor"
      },
      {
        "name": "login",
        "type": "STRING",
        "description": "Actor's GitHub login"
      },
      {
        "name": "gravatar_id",
        "type": "STRING",
        "description": "Actor's Gravatar ID"
      },
      {
        "name": "avatar_url",
        "type": "STRING",
        "description": "Actor's Gravatar URL"
      },
      {
        "name": "url",
        "type": "STRING",
        "description": "Actor's profile URL"
      }
    ]
  },
  {
    "name": "org",
    "type": "RECORD",
    "description": "GitHub org of the associated repo",
    "fields": [
      {
        "name": "id",
        "type": "INTEGER",
        "description": "Numeric ID of the GitHub org"
      },
      {
        "name": "login",
        "type": "STRING",
        "description": "Org's GitHub login"
      },
      {
        "name": "gravatar_id",
        "type": "STRING",
        "description": "Org's Gravatar ID"
      },
      {
        "name": "avatar_url",
        "type": "STRING",
        "description": "Org's Gravatar URL"
      },
      {
        "name": "url",
        "type": "STRING",
        "description": "Org's profile URL"
      }
    ]
  },
  {
    "name": "created_at",
    "type": "TIMESTAMP",
    "description": "Timestamp of associated event"
  },
  {
    "name": "id",
    "type": "STRING",
    "description": "Unique event ID"
  }
]
