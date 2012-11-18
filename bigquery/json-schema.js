[
  {
    "name": "repo",
    "type": "record",
    "fields": [
      {
        "name": "id",
        "type": "integer"
      },
      {
        "name": "url",
        "type": "string"
      },
      {
        "name": "name",
        "type": "string"
      }
    ]
  },
  {
    "name": "type",
    "type": "string"
  },
  {
    "name": "public",
    "type": "boolean"
  },
  {
    "name": "created_at",
    "type": "string"
  },
  {
    "name": "payload",
    "type": "record",
    "fields": [
      {
        "mode": "repeated",
        "name": "shas",
        "type": "record",
        "fields": [
          {
            "name": "id",
            "type": "string"
          },
          {
            "name": "email",
            "type": "string"
          },
          {
            "name": "msg",
            "type": "string"
          },
                    {
            "name": "name",
            "type": "string"
          },
          {
            "name": "flag",
            "type": "boolean"
          }
        ]
      },
      {
        "name": "repo",
        "type": "string"
      },
      {
        "name": "actor",
        "type": "string"
      },
      {
        "name": "ref",
        "type": "string"
      },
      {
        "name": "size",
        "type": "integer"
      },
      {
        "name": "head",
        "type": "string"
      },
      {
        "name": "actor_gravatar",
        "type": "string"
      },
      {
        "name": "push_id",
        "type": "integer"
      },
      {
        "name": "number",
        "type": "integer"
      },
      {
        "name": "pull_request",
        "type": "record",
        "fields": [
          {
            "name": "changed_files",
            "type": "integer"
          },
          {
            "name": "master_branch",
            "type": "string"
          },
          {
            "name": "patch_url",
            "type": "string"
          },
          {
            "name": "merged_by",
            "type": "record",
            "fields": [
              {
                "name": "gravatar_id",
                "type": "string"
              },
              {
                "name": "urls",
                "type": "record",
                "fields": [
                  {
                    "name": "self",
                    "type": "string"
                  }
                ]
              },
              {
                "name": "id",
                "type": "integer"
              },
              {
                "name": "login",
                "type": "string"
              },
              {
                "name": "url",
                "type": "string"
              },
              {
                "name": "avatar_url",
                "type": "string"
              }
            ]
          },
          {
            "name": "body",
            "type": "string"
          },
          {
            "name": "merge_commit_sha",
            "type": "string"
          },
          {
            "name": "head",
            "type": "record",
            "fields": [
              {
                "name": "sha",
                "type": "string"
              },
              {
                "name": "ref",
                "type": "string"
              },
              {
                "name": "label",
                "type": "string"
              },
              {
                "name": "user",
                "type": "record",
                "fields": [
                  {
                    "name": "gravatar_id",
                    "type": "string"
                  },
                  {
                    "name": "urls",
                    "type": "record",
                    "fields": [
                      {
                        "name": "self",
                        "type": "string"
                      }
                    ]
                  },
                  {
                    "name": "id",
                    "type": "integer"
                  },
                  {
                    "name": "login",
                    "type": "string"
                  },
                  {
                    "name": "url",
                    "type": "string"
                  },
                  {
                    "name": "avatar_url",
                    "type": "string"
                  }
                ]
              },
              {
                "name": "repo",
                "type": "record",
                "fields": [
                  {
                    "name": "has_downloads",
                    "type": "boolean"
                  },
                  {
                    "name": "private",
                    "type": "boolean"
                  },
                  {
                    "name": "homepage",
                    "type": "string"
                  },
                  {
                    "name": "forks_count",
                    "type": "integer"
                  },
                  {
                    "name": "forks",
                    "type": "integer"
                  },
                  {
                    "name": "mirror_url",
                    "type": "string"
                  },
                  {
                    "name": "has_issues",
                    "type": "boolean"
                  },
                  {
                    "name": "ssh_url",
                    "type": "string"
                  },
                  {
                    "name": "updated_at",
                    "type": "string"
                  },
                  {
                    "name": "open_issues_count",
                    "type": "integer"
                  },
                  {
                    "name": "name",
                    "type": "string"
                  },
                  {
                    "name": "master_branch",
                    "type": "string"
                  },
                  {
                    "name": "html_url",
                    "type": "string"
                  },
                  {
                    "name": "git_url",
                    "type": "string"
                  },
                  {
                    "name": "urls",
                    "type": "record",
                    "fields": [
                      {
                        "name": "self",
                        "type": "string"
                      }
                    ]
                  },
                  {
                    "name": "id",
                    "type": "integer"
                  },
                  {
                    "name": "watchers",
                    "type": "integer"
                  },
                  {
                    "name": "description",
                    "type": "string"
                  },
                  {
                    "name": "open_issues",
                    "type": "integer"
                  },
                  {
                    "name": "owner",
                    "type": "record",
                    "fields": [
                      {
                        "name": "gravatar_id",
                        "type": "string"
                      },
                      {
                        "name": "urls",
                        "type": "record",
                        "fields": [
                          {
                            "name": "self",
                            "type": "string"
                          }
                        ]
                      },
                      {
                        "name": "id",
                        "type": "integer"
                      },
                      {
                        "name": "login",
                        "type": "string"
                      },
                      {
                        "name": "url",
                        "type": "string"
                      },
                      {
                        "name": "avatar_url",
                        "type": "string"
                      }
                    ]
                  },
                  {
                    "name": "full_name",
                    "type": "string"
                  },
                  {
                    "name": "watchers_count",
                    "type": "integer"
                  },
                  {
                    "name": "url",
                    "type": "string"
                  },
                  {
                    "name": "size",
                    "type": "integer"
                  },
                  {
                    "name": "pushed_at",
                    "type": "string"
                  },
                  {
                    "name": "language",
                    "type": "string"
                  },
                  {
                    "name": "has_wiki",
                    "type": "boolean"
                  },
                  {
                    "name": "svn_url",
                    "type": "string"
                  },
                  {
                    "name": "created_at",
                    "type": "string"
                  },
                  {
                    "name": "fork",
                    "type": "boolean"
                  },
                  {
                    "name": "clone_url",
                    "type": "string"
                  }
                ]
              }
            ]
          },
          {
            "name": "commits",
            "type": "integer"
          },
          {
            "name": "assignee",
            "type": "string"
          },
          {
            "name": "updated_at",
            "type": "string"
          },
          {
            "name": "_links",
            "type": "record",
            "fields": [
              {
                "name": "issue",
                "type": "record",
                "fields": [
                  {
                    "name": "href",
                    "type": "string"
                  }
                ]
              },
              {
                "name": "html",
                "type": "record",
                "fields": [
                  {
                    "name": "href",
                    "type": "string"
                  }
                ]
              },
              {
                "name": "review_comments",
                "type": "record",
                "fields": [
                  {
                    "name": "href",
                    "type": "string"
                  }
                ]
              },
              {
                "name": "self",
                "type": "record",
                "fields": [
                  {
                    "name": "href",
                    "type": "string"
                  }
                ]
              },
              {
                "name": "comments",
                "type": "record",
                "fields": [
                  {
                    "name": "href",
                    "type": "string"
                  }
                ]
              }
            ]
          },
          {
            "name": "html_url",
            "type": "string"
          },
          {
            "name": "closed_at",
            "type": "string"
          },
          {
            "name": "number",
            "type": "integer"
          },
          {
            "name": "title",
            "type": "string"
          },
          {
            "name": "deletions",
            "type": "integer"
          },
          {
            "name": "milestone",
            "type": "string"
          },
          {
            "name": "id",
            "type": "integer"
          },
          {
            "name": "merged_at",
            "type": "string"
          },
          {
            "name": "review_comments",
            "type": "integer"
          },
          {
            "name": "url",
            "type": "string"
          },
          {
            "name": "additions",
            "type": "integer"
          },
          {
            "name": "mergeable_state",
            "type": "string"
          },
          {
            "name": "diff_url",
            "type": "string"
          },
          {
            "name": "state",
            "type": "string"
          },
          {
            "name": "user",
            "type": "record",
            "fields": [
              {
                "name": "gravatar_id",
                "type": "string"
              },
              {
                "name": "urls",
                "type": "record",
                "fields": [
                  {
                    "name": "self",
                    "type": "string"
                  }
                ]
              },
              {
                "name": "id",
                "type": "integer"
              },
              {
                "name": "login",
                "type": "string"
              },
              {
                "name": "url",
                "type": "string"
              },
              {
                "name": "avatar_url",
                "type": "string"
              }
            ]
          },
          {
            "name": "created_at",
            "type": "string"
          },
          {
            "name": "merged",
            "type": "boolean"
          },
          {
            "name": "comments",
            "type": "integer"
          },
          {
            "name": "issue_url",
            "type": "string"
          },
          {
            "name": "base",
            "type": "record",
            "fields": [
              {
                "name": "sha",
                "type": "string"
              },
              {
                "name": "ref",
                "type": "string"
              },
              {
                "name": "label",
                "type": "string"
              },
              {
                "name": "user",
                "type": "record",
                "fields": [
                  {
                    "name": "gravatar_id",
                    "type": "string"
                  },
                  {
                    "name": "urls",
                    "type": "record",
                    "fields": [
                      {
                        "name": "self",
                        "type": "string"
                      }
                    ]
                  },
                  {
                    "name": "id",
                    "type": "integer"
                  },
                  {
                    "name": "login",
                    "type": "string"
                  },
                  {
                    "name": "url",
                    "type": "string"
                  },
                  {
                    "name": "avatar_url",
                    "type": "string"
                  }
                ]
              },
              {
                "name": "repo",
                "type": "record",
                "fields": [
                  {
                    "name": "has_downloads",
                    "type": "boolean"
                  },
                  {
                    "name": "private",
                    "type": "boolean"
                  },
                  {
                    "name": "homepage",
                    "type": "string"
                  },
                  {
                    "name": "forks_count",
                    "type": "integer"
                  },
                  {
                    "name": "forks",
                    "type": "integer"
                  },
                  {
                    "name": "mirror_url",
                    "type": "string"
                  },
                  {
                    "name": "has_issues",
                    "type": "boolean"
                  },
                  {
                    "name": "ssh_url",
                    "type": "string"
                  },
                  {
                    "name": "updated_at",
                    "type": "string"
                  },
                  {
                    "name": "open_issues_count",
                    "type": "integer"
                  },
                  {
                    "name": "name",
                    "type": "string"
                  },
                  {
                    "name": "html_url",
                    "type": "string"
                  },
                  {
                    "name": "git_url",
                    "type": "string"
                  },
                  {
                    "name": "urls",
                    "type": "record",
                    "fields": [
                      {
                        "name": "self",
                        "type": "string"
                      }
                    ]
                  },
                  {
                    "name": "id",
                    "type": "integer"
                  },
                  {
                    "name": "watchers",
                    "type": "integer"
                  },
                  {
                    "name": "description",
                    "type": "string"
                  },
                  {
                    "name": "open_issues",
                    "type": "integer"
                  },
                  {
                    "name": "owner",
                    "type": "record",
                    "fields": [
                      {
                        "name": "gravatar_id",
                        "type": "string"
                      },
                      {
                        "name": "urls",
                        "type": "record",
                        "fields": [
                          {
                            "name": "self",
                            "type": "string"
                          }
                        ]
                      },
                      {
                        "name": "id",
                        "type": "integer"
                      },
                      {
                        "name": "login",
                        "type": "string"
                      },
                      {
                        "name": "url",
                        "type": "string"
                      },
                      {
                        "name": "avatar_url",
                        "type": "string"
                      }
                    ]
                  },
                  {
                    "name": "full_name",
                    "type": "string"
                  },
                  {
                    "name": "watchers_count",
                    "type": "integer"
                  },
                  {
                    "name": "url",
                    "type": "string"
                  },
                  {
                    "name": "size",
                    "type": "integer"
                  },
                  {
                    "name": "pushed_at",
                    "type": "string"
                  },
                  {
                    "name": "master_branch",
                    "type": "string"
                  },
                  {
                    "name": "language",
                    "type": "string"
                  },
                  {
                    "name": "has_wiki",
                    "type": "boolean"
                  },
                  {
                    "name": "svn_url",
                    "type": "string"
                  },
                  {
                    "name": "created_at",
                    "type": "string"
                  },
                  {
                    "name": "fork",
                    "type": "boolean"
                  },
                  {
                    "name": "clone_url",
                    "type": "string"
                  }
                ]
              }
            ]
          },
          {
            "name": "mergeable",
            "type": "boolean"
          }
        ]
      },
      {
        "name": "action",
        "type": "string"
      },
      {
        "name": "name",
        "type": "string"
      },
      {
        "name": "object",
        "type": "string"
      },
      {
        "name": "object_name",
        "type": "string"
      },
      {
        "name": "comment_id",
        "type": "integer"
      },
      {
        "name": "commit",
        "type": "string"
      },
      {
        "name": "issue",
        "type": "integer"
      },
      {
        "name": "title",
        "type": "string"
      },
      {
        "name": "summary",
        "type": "string"
      },
      {
        "name": "sha",
        "type": "string"
      },
      {
        "name": "page_name",
        "type": "string"
      },
      {
        "name": "target",
        "type": "record",
        "fields": [
          {
            "name": "repos",
            "type": "integer"
          },
          {
            "name": "id",
            "type": "integer"
          },
          {
            "name": "gravatar_id",
            "type": "string"
          },
          {
            "name": "login",
            "type": "string"
          },
          {
            "name": "followers",
            "type": "integer"
          }
        ]
      },
      {
        "name": "desc",
        "type": "string"
      },
      {
        "name": "url",
        "type": "string"
      },
      {
        "name": "snippet",
        "type": "string"
      },
      {
        "name": "forkee",
        "type": "record",
        "fields": [
          {
            "name": "watchers",
            "type": "integer"
          },
          {
            "name": "open_issues",
            "type": "integer"
          },
          {
            "name": "created_at",
            "type": "string"
          },
          {
            "name": "git_url",
            "type": "string"
          },
          {
            "name": "fork",
            "type": "boolean"
          },
          {
            "name": "updated_at",
            "type": "string"
          },
          {
            "name": "id",
            "type": "integer"
          },
          {
            "name": "language",
            "type": "string"
          },
          {
            "name": "has_wiki",
            "type": "boolean"
          },
          {
            "name": "public",
            "type": "boolean"
          },
          {
            "name": "html_url",
            "type": "string"
          },
          {
            "name": "name",
            "type": "string"
          },
          {
            "name": "master_branch",
            "type": "string"
          },
          {
            "name": "description",
            "type": "string"
          },
          {
            "name": "has_issues",
            "type": "boolean"
          },
          {
            "name": "clone_url",
            "type": "string"
          },
          {
            "name": "mirror_url",
            "type": "string"
          },
          {
            "name": "pushed_at",
            "type": "string"
          },
          {
            "name": "ssh_url",
            "type": "string"
          },
          {
            "name": "forks",
            "type": "integer"
          },
          {
            "name": "url",
            "type": "string"
          },
          {
            "name": "has_downloads",
            "type": "boolean"
          },
          {
            "name": "owner",
            "type": "record",
            "fields": [
              {
                "name": "id",
                "type": "integer"
              },
              {
                "name": "login",
                "type": "string"
              },
              {
                "name": "url",
                "type": "string"
              },
              {
                "name": "avatar_url",
                "type": "string"
              },
              {
                "name": "gravatar_id",
                "type": "string"
              }
            ]
          },
          {
            "name": "homepage",
            "type": "string"
          },
          {
            "name": "size",
            "type": "integer"
          },
          {
            "name": "private",
            "type": "boolean"
          },
          {
            "name": "svn_url",
            "type": "string"
          }
        ]
      },
      {
        "name": "ref_type",
        "type": "string"
      },
      {
        "name": "member",
        "type": "record",
        "fields": [
          {
            "name": "id",
            "type": "integer"
          },
          {
            "name": "login",
            "type": "string"
          },
          {
            "name": "urls",
            "type": "record",
            "fields": [
              {
                "name": "self",
                "type": "string"
              }
            ]
          },
          {
            "name": "url",
            "type": "string"
          },
          {
            "name": "avatar_url",
            "type": "string"
          },
          {
            "name": "gravatar_id",
            "type": "string"
          }
        ]
      },
      {
        "name": "id",
        "type": "integer"
      },
      {
        "name": "original",
        "type": "string"
      },
      {
        "name": "issue_id",
        "type": "integer"
      },
      {
        "name": "description",
        "type": "string"
      },
      {
        "name": "master_branch",
        "type": "string"
      },
      {
        "name": "after",
        "type": "string"
      },
      {
        "name": "before",
        "type": "string"
      },
      {
        "mode": "repeated",
        "name": "pages",
        "type": "record",
        "fields": [
          {
            "name": "html_url",
            "type": "string"
          },
          {
            "name": "summary",
            "type": "string"
          },
          {
            "name": "page_name",
            "type": "string"
          },
          {
            "name": "action",
            "type": "string"
          },
          {
            "name": "title",
            "type": "string"
          },
          {
            "name": "sha",
            "type": "string"
          }
        ]
      },
      {
        "name": "comment",
        "type": "record",
        "fields": [
          {
            "name": "path",
            "type": "string"
          },
          {
            "name": "body",
            "type": "string"
          },
          {
            "name": "position",
            "type": "integer"
          },
          {
            "name": "updated_at",
            "type": "string"
          },
          {
            "name": "_links",
            "type": "record",
            "fields": [
              {
                "name": "pull_request",
                "type": "record",
                "fields": [
                  {
                    "name": "href",
                    "type": "string"
                  }
                ]
              },
              {
                "name": "html",
                "type": "record",
                "fields": [
                  {
                    "name": "href",
                    "type": "string"
                  }
                ]
              },
              {
                "name": "self",
                "type": "record",
                "fields": [
                  {
                    "name": "href",
                    "type": "string"
                  }
                ]
              }
            ]
          },
          {
            "name": "original_position",
            "type": "integer"
          },
          {
            "name": "id",
            "type": "integer"
          },
          {
            "name": "commit_id",
            "type": "string"
          },
          {
            "name": "url",
            "type": "string"
          },
          {
            "name": "original_commit_id",
            "type": "string"
          },
          {
            "name": "user",
            "type": "record",
            "fields": [
              {
                "name": "gravatar_id",
                "type": "string"
              },
              {
                "name": "urls",
                "type": "record",
                "fields": [
                  {
                    "name": "self",
                    "type": "string"
                  }
                ]
              },
              {
                "name": "id",
                "type": "integer"
              },
              {
                "name": "login",
                "type": "string"
              },
              {
                "name": "url",
                "type": "string"
              },
              {
                "name": "avatar_url",
                "type": "string"
              }
            ]
          },
          {
            "name": "created_at",
            "type": "string"
          }
        ]
      },
      {
        "mode": "repeated",
        "name": "commits",
        "type": "record",
        "fields": [
          {
            "name": "sha",
            "type": "string"
          },
          {
            "name": "author",
            "type": "record",
            "fields": [
              {
                "name": "email",
                "type": "string"
              },
              {
                "name": "name",
                "type": "string"
              }
            ]
          },
          {
            "name": "url",
            "type": "string"
          },
          {
            "name": "message",
            "type": "string"
          }
        ]
      },
      {
        "name": "gist",
        "type": "record",
        "fields": [
          {
            "name": "user",
            "type": "record",
            "fields": [
              {
                "name": "id",
                "type": "integer"
              },
              {
                "name": "login",
                "type": "string"
              },
              {
                "name": "url",
                "type": "string"
              },
              {
                "name": "avatar_url",
                "type": "string"
              },
              {
                "name": "gravatar_id",
                "type": "string"
              }
            ]
          },
          {
            "name": "created_at",
            "type": "string"
          },
          {
            "name": "updated_at",
            "type": "string"
          },
          {
            "name": "id",
            "type": "string"
          },
          {
            "name": "public",
            "type": "boolean"
          },
          {
            "name": "html_url",
            "type": "string"
          },
          {
            "name": "files",
            "type": "record",
            "fields": [
              {
                "name": "string",
                "type": "string"
              }
            ]
          },
          {
            "name": "description",
            "type": "string"
          },
          {
            "name": "git_push_url",
            "type": "string"
          },
          {
            "name": "url",
            "type": "string"
          },
          {
            "name": "comments",
            "type": "integer"
          },
          {
            "name": "git_pull_url",
            "type": "string"
          }
        ]
      },
      {
        "name": "download",
        "type": "record",
        "fields": [
          {
            "name": "created_at",
            "type": "string"
          },
          {
            "name": "id",
            "type": "integer"
          },
          {
            "name": "download_count",
            "type": "integer"
          },
          {
            "name": "html_url",
            "type": "string"
          },
          {
            "name": "name",
            "type": "string"
          },
          {
            "name": "description",
            "type": "string"
          },
          {
            "name": "content_type",
            "type": "string"
          },
          {
            "name": "url",
            "type": "string"
          },
          {
            "name": "size",
            "type": "integer"
          }
        ]
      }
    ]
  },
  {
    "name": "actor",
    "type": "string"
  },
  {
    "name": "id",
    "type": "string"
  },
  {
    "name": "org",
    "type": "record",
    "fields": [
      {
        "name": "gravatar_id",
        "type": "string"
      },
      {
        "name": "id",
        "type": "integer"
      },
      {
        "name": "url",
        "type": "string"
      },
      {
        "name": "avatar_url",
        "type": "string"
      },
      {
        "name": "login",
        "type": "string"
      }
    ]
  },
  {
    "name": "repository",
    "type": "record",
    "fields": [
      {
        "name": "open_issues",
        "type": "integer"
      },
      {
        "name": "watchers",
        "type": "integer"
      },
      {
        "name": "pushed_at",
        "type": "string"
      },
      {
        "name": "homepage",
        "type": "string"
      },
      {
        "name": "url",
        "type": "string"
      },
      {
        "name": "has_downloads",
        "type": "boolean"
      },
      {
        "name": "fork",
        "type": "boolean"
      },
      {
        "name": "has_issues",
        "type": "boolean"
      },
      {
        "name": "forks",
        "type": "integer"
      },
      {
        "name": "size",
        "type": "integer"
      },
      {
        "name": "private",
        "type": "boolean"
      },
      {
        "name": "created_at",
        "type": "string"
      },
      {
        "name": "name",
        "type": "string"
      },
      {
        "name": "owner",
        "type": "string"
      },
      {
        "name": "has_wiki",
        "type": "boolean"
      },
      {
        "name": "description",
        "type": "string"
      },
      {
        "name": "language",
        "type": "string"
      },
      {
        "name": "master_branch",
        "type": "string"
      },
      {
        "name": "organization",
        "type": "string"
      },
      {
        "name": "integrate_branch",
        "type": "string"
      },
      {
        "name": "stargazers",
        "type": "integer"
      },
      {
        "name": "id",
        "type": "integer"
      }
    ]
  },
  {
    "name": "actor_attributes",
    "type": "record",
    "fields": [
      {
        "name": "gravatar_id",
        "type": "string"
      },
      {
        "name": "type",
        "type": "string"
      },
      {
        "name": "login",
        "type": "string"
      },
      {
        "name": "name",
        "type": "string"
      },
      {
        "name": "location",
        "type": "string"
      },
      {
        "name": "blog",
        "type": "string"
      },
      {
        "name": "email",
        "type": "string"
      },
      {
        "name": "company",
        "type": "string"
      }
    ]
  },
  {
    "name": "url",
    "type": "string"
  }
]
