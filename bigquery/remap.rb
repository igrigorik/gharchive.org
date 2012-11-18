class String
  def remap
    case self
    when 'repo_url' then 'repository_url'
    when 'repo_name' then 'repository_name'
    when 'actor_login' then 'actor'
    when 'actor_gravatar_id' then 'actor_attributes_gravatar_id'
    when 'org_login' then 'repository_organization'
    when 'payload_snippet' then 'payload_description'
    when 'payload_pull_request_issue_id' then 'payload_issue_id'
    when 'payload_member' then 'payload_member_login'
    when 'payload_issue_number' then 'payload_issue'
    when 'payload_issue_state' then 'payload_action'
    when 'payload_gist_created_at' then 'created_at'
    when 'payload_gist_user_gravatar_id' then 'actor_attributes_gravatar_id'
    when 'payload_gist_user_login' then 'actor_attributes_login'
    when 'payload_gist_id' then 'payload_id'
    when 'payload_gist_description' then 'payload_desc'
    when 'payload_gist_html_url' then 'payload_url'
    when 'payload_gist_public' then 'public'
    when 'payload_gist_user' then 'actor_attributes_login'
    else
      self
    end
  end

  def clean!
    return if
    self.gsub!('api.github.dev/repos', 'github.com')
  end
end

IGNORED = %w[
  2012...
  August ...

  payload_pull_request_head_repo_full_name
  payload_pull_request__links_issue_href
  payload_pull_request_base_repo_full_name
  payload_pull_request_head_repo

  payload_comment__links_html_href
  payload_comment__links_pull_request_href
  payload_comment__links_self_href

  payload_pull_request_assignee
  payload_pull_request_milestone
  payload_pull_request_assignee_url
  payload_pull_request_assignee_id
  payload_pull_request_assignee_login
  payload_pull_request_assignee_gravatar_id
  payload_pull_request_assignee_avatar_url

  payload_pull_request_milestone_id
  payload_pull_request_milestone_number
  payload_pull_request_milestone_created_at
  payload_pull_request_milestone_state
  payload_pull_request_milestone_due_on
  payload_pull_request_milestone_creator_id
  payload_pull_request_milestone_creator_login
  payload_pull_request_milestone_creator_avatar_url
  payload_pull_request_milestone_creator_gravatar_id
  payload_pull_request_milestone_creator_url
  payload_pull_request_milestone_closed_issues
  payload_pull_request_milestone_open_issues
  payload_pull_request_milestone_description
  payload_pull_request_milestone_url
  payload_pull_request_milestone_title

  September...

  repository_stargazers

  payload_pull_request_head_repo_open_issues_count
  payload_pull_request_head_repo_watchers_count
  payload_pull_request_head_repo_forks_count
  payload_pull_request_base_repo_open_issues_count
  payload_pull_request_base_repo_watchers_count
  payload_pull_request_base_repo_forks_count
  payload_pull_request_mergeable_state

  October...

  repository_id
  payload_pull_request_base_repo_owner_urls_self
  payload_pull_request_base_repo_urls_self
  payload_pull_request_merged_by_urls_self
  payload_pull_request_base_user_urls_self
  payload_pull_request_head_user_urls_self
  payload_pull_request_head_repo_owner_urls_self
  payload_pull_request_head_repo_urls_self
  payload_pull_request_user_urls_self
  payload_pull_request_merge_commit_sha
  payload_pull_request_assignee_urls_self
  payload_pull_request_milestone_creator_urls_self
  payload_member_urls_self
  payload_comment_user_urls_self

  November...

  payload_pull_request_head_repo_default_branch
  payload_pull_request_base_repo_default_branch


  2011....

  payload_download_created_at
  payload_download_content_type
  payload_download_name
  payload_download_id
  payload_download_description
  payload_download_html_url
  payload_download_url
  payload_download_size
  payload_download_download_count

  payload_comment_line
  payload_comment_html_url

  payload_gist_git_pull_url
  payload_gist_git_push_url
  payload_gist_url
  payload_gist_created_at
  payload_gist_updated_at
  payload_gist_user_gravatar_id
  payload_gist_user_id
  payload_gist_user_url

  id
  repo_id
  payload_repo
  payload_actor
  payload_actor_gravatar
  payload_push_id
  actor_id
  actor_url
  actor_avatar_url

  org_gravatar_id
  org_id
  org_url
  org_avatar_url

  payload_object
  payload_object_name
  payload_forkee
  payload_original
  payload_forkee_id
  payload_forkee_name
  payload_forkee_public

  payload_issue_milestone_created_at
  payload_issue_milestone_state
  payload_issue_milestone_due_on
  payload_issue_milestone_closed_issues
  payload_issue_milestone_creator_gravatar_id
  payload_issue_milestone_creator_id
  payload_issue_milestone_creator_url
  payload_issue_milestone_creator_login
  payload_issue_milestone_creator_avatar_url
  payload_issue_milestone_number
  payload_issue_milestone_title
  payload_issue_milestone_description
  payload_issue_milestone_url
  payload_issue_milestone_open_issues

  payload_issue_body
  payload_issue_assignee_gravatar_id
  payload_issue_assignee_id
  payload_issue_assignee_url
  payload_issue_assignee_login
  payload_issue_assignee_avatar_url
  payload_issue_pull_request_patch_url
  payload_issue_pull_request_html_url
  payload_issue_pull_request_diff_url
  payload_issue_title
  payload_issue_closed_at
  payload_issue_html_url
  payload_issue_url
  payload_issue_created_at
  payload_issue_updated_at
  payload_issue_user_gravatar_id
  payload_issue_user_id
  payload_issue_user_url
  payload_issue_user_login
  payload_issue_user_avatar_url

  payload_issue_comments
  payload_issue_body
  payload_issue_assignee_gravatar_id
  payload_issue_assignee_id
  payload_issue_assignee_url
  payload_issue_assignee
  payload_issue_milestone

  payload_target_created_at
  payload_target_public_repos
  payload_target_type
  payload_target_company
  payload_target_name
  payload_target_blog
  payload_target_email
  payload_target_location
  payload_target_hireable
  payload_target_bio
  payload_target_public_gists
  payload_target_html_url
  payload_target_url
  payload_target_following
  payload_target_following

  payload_forkee_created_at
  payload_forkee_pushed_at
  payload_forkee_private
  payload_forkee_updated_at
  payload_forkee_clone_url
  payload_forkee_watchers
  payload_forkee_master_branch
  payload_forkee_svn_url
  payload_forkee_forks
  payload_forkee_language
  payload_forkee_owner_gravatar_id
  payload_forkee_owner_id
  payload_forkee_owner_url
  payload_forkee_owner_login
  payload_forkee_owner_avatar_url
  payload_forkee_homepage
  payload_forkee_description
  payload_forkee_git_url
  payload_forkee_html_url
  payload_forkee_open_issues
  payload_forkee_url
  payload_forkee_size
  payload_forkee_fork
  payload_forkee_ssh_url
  payload_target_avatar_url

  payload_gist_updated_at
  payload_gist_user_id
  payload_gist_user_url
  payload_gist_user_avatar_url
  payload_gist_comments
]
