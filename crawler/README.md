# Changes to json schema

Github continues to change and evolve their schema. 
Because of this json format in which data is stored also changes.
Here you can find information what was changed and when.


## 2012-03-11 changes

There is a lot more information about repository now.

### Compatibility issues:
  
  * **repo** key name was changed to **repository**. 

### New schema example:

```json
{
	"repository": {
	    "homepage": "",
	    "watchers": 2,
	    "pushed_at": "2012/03/24 00:00:03 -0700",
	    "url": "https://github.com/musubu/node-opds-parser",
	    "has_downloads": true,
	    "language": "JavaScript",
	    "has_issues": true,
	    "forks": 1,
	    "fork": false,
	    "created_at": "2012/03/19 03:47:00 -0700",
	    "description": "OPDS Catalog Feed Parser for node",
	    "size": 260,
	    "private": false,
	    "has_wiki": true,
	    "name": "node-opds-parser",
	    "owner": "musubu",
	    "open_issues": 0
	},
	"actor_attributes": {
	    "gravatar_id": "a4a6610eae5ab8c07f7f7c4020c83eba",
	    "type": "User",
	    "login": "musubu"
	},
	"created_at": "2012/03/24 00:00:04 -0700",
	"public": true,
	"actor": "musubu",
	"payload": {
	    "head": "f0587048e0fd62a1c5771951ed8639b2a4b9956b",
	    "size": 1,
	    "shas": [
	        [
	            "f0587048e0fd62a1c5771951ed8639b2a4b9956b",
	            "dev@musubu.co.jp",
	            "releasing version 0.1.3.",
	            "Musubu Inc",
	            true
	        ]
	    ],
	    "ref": "refs/heads/master"
	},
	"url": "https://github.com/musubu/node-opds-parser/compare/d8d0b627a6...f0587048e0",
	"type": "PushEvent"
}
```


## 2011-03 first json schema

Bellow you can find sample record from 2011-03 datasets:

```json
{
	"repo": {
	    "id": 991048,
	    "url": "https://api.github.dev/repos/cbeer/blacklight_user_generated_content",
	    "name": "cbeer/blacklight_user_generated_content"
	},
	"type": "PushEvent",
	"public": true,
	"created_at": "2011-03-01T00:00:00Z",
	"payload": {
	    "shas": [
	        [
	            "b6b9e0729643f8debf9dbd9ec3dfcab1a6b8ffcb",
	            "chris@cbeer.info",
	            "document filter for comments index",
	            "Chris Beer"
	        ],
	        [
	            "8ca5cf297e3b5bbdd19654ca289ede782a82ac1f",
	            "chris@cbeer.info",
	            "fix up comments @document instance variable",
	            "Chris Beer"
	        ]
	    ],
	    "repo": "cbeer/blacklight_user_generated_content",
	    "actor": "cbeer",
	    "ref": "refs/heads/master",
	    "size": 2,
	    "head": "8ca5cf297e3b5bbdd19654ca289ede782a82ac1f",
	    "actor_gravatar": "604d4106c02e6e5525a7768c2f398baa",
	    "push_id": 25733409
	},
	"actor": {
	    "gravatar_id": "604d4106c02e6e5525a7768c2f398baa",
	    "id": 111218,
	    "url": "https://api.github.dev/users/cbeer",
	    "avatar_url": "https://secure.gravatar.com/avatar/604d4106c02e6e5525a7768c2f398baa?",
	    "login": "cbeer"
	},
	"id": "1158443437"
}
```
