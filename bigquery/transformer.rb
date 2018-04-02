require 'digest'
require 'time'
require 'yajl'

#
# Courtesy of @arfon
# - https://github.com/arfon/gh_archive_parser
#

class EventParseError < StandardError; end

class EventTransform
  attr_accessor :actor, :created_at, :raw_event, :id, :org, :other, :payload, :is_public, :repo, :type

  def initialize(event_json)
    @raw_event = event_json
    @other = Hash.new
  end

  def process
    sanitize
    extract_and_set_fields
  end

  # Return the event hash as described in
  # https://github.com/igrigorik/gharchive.org/blob/master/bigquery/schema.js
  # HACK HACK HACK
  def parsed_event
    event = {
              'payload' => Yajl::Encoder.encode(payload),
              'public' => is_public
            }

    ['repo', 'actor', 'created_at', 'id', 'org', 'type'].each do |field|
      # Don't include the field in the return event if it's empty.
      value = self.send(field)
      next if value.nil? || value.empty?
      event[field] = value
    end

    # Worst. Code. Ever.
    event['other'] = Yajl::Encoder.encode(other) if !other.empty?

    return event
  end

  # Scrub emails from push events. Could include further logic in future
  def sanitize
    scrub_payload_emails
    scrub_actor_attributes
  end

  # Extract the top-level schema fields from the raw event body and do any
  # necessary processing of the fields
  def extract_and_set_fields
    @type = raw_event['type']
    @is_public = raw_event['public']
    @payload = raw_event['payload']
    @id = raw_event['id']
    # https://github.com/igrigorik/gharchive.org/blob/c9ae11426e5bcc30fe15617d009dfc602697ecde/bigquery/schema.js#L17-L38
    @repo = parse_repo

    # https://github.com/igrigorik/gharchive.org/blob/c9ae11426e5bcc30fe15617d009dfc602697ecde/bigquery/schema.js#L39-L70
    @actor = parse_actor

    # https://github.com/igrigorik/gharchive.org/blob/c9ae11426e5bcc30fe15617d009dfc602697ecde/bigquery/schema.js#L71-L102
    @org = parse_org

    @created_at = parse_created_at
  end

  # The actor field needs special handling:
  # - 2013/2014 events have `actor_attributes` (from the timeline.json feed?)
  # - Sometimes the events only have an actor key (string) which we want to
  #   massage into the actor['login'] field.
  def parse_actor
    if raw_event.has_key?('actor_attributes')
      @actor = parse_field('actor_attributes', %w{id login gravatar_id avatar_url url})
    elsif raw_event.has_key?('actor') && raw_event['actor'].is_a?(String)
      @actor = {'login' => raw_event['actor'] }
    else
      @actor = parse_field('actor', %w{id login gravatar_id avatar_url url})
    end
  end

  # Can be repo or repository. We need to handle both cases.
  def parse_repo
    if raw_event.has_key?('repository')
      @repo = parse_field('repository', %w{id url name})
    else
      @repo = parse_field('repo', %w{id url name})
    end
  end

  # The org field needs special handling:
  # - 2013/2014 events have the organization field on the repository key
  # - Other events have `org` broken out into a separate field.
  def parse_org
    if raw_event.has_key?('repository') && raw_event['repository'].has_key?('organization')
      @org = { 'login' => raw_event['repository']['organization'] }
    else
      @org = parse_field('org', %w{id login gravatar_id avatar_url url})
    end
  end

  # Extract a field from the raw event body and extract the expected entries
  # for extraneous entries add them to the 'other' field.
  # If a field is empty then drop the field (as Big Query doesn't like null values)
  def parse_field(field_name, expected_entries)
    event_field = raw_event.dup.delete(field_name)

    # Sometimes this is blank (e.g. for anonymous Gists actor is nil)
    if event_field.nil?
      return nil
    end

    parsed = {}

    expected_entries.each do |field|
      extracted = event_field.delete(field)
      next if extracted.nil?
      parsed[field] = extracted
    end

    # Are there extra fields?
    # If so, throw them into the other key
    if event_field.keys.any?
      @other[field_name] = event_field
    end

    return parsed
  end

  def parse_created_at
    return Time.parse(raw_event['created_at']).utc.strftime('%Y-%m-%d %T')
  end

  def scrub_actor_attributes
    if raw_event.has_key?('actor_attributes')
      raw_event['actor_attributes']['email'] = sanitize_email(raw_event['actor_attributes']['email'])
    end
  end

  def scrub_payload_emails
    return unless raw_event['payload']

    if raw_event['payload'].has_key?('shas')
      commits = raw_event['payload']['shas']

      # Older format PushEvents have commits described as 'shas'. These
      # have format ['git sha', 'author email', 'commit message', 'author name']
      commits.each do |commit|
        commit[1] = sanitize_email(commit[1])
      end
    elsif raw_event['payload'].has_key?('commits')

      # Newer PushEvents have a 'commits' key with nested attributes:
      # "commits": [
      #   {
      #     "sha": "5636aa2f6f249f22e76b20e5caeb84096b7302ce",
      #     "author" : {
      #       "email": "email@example.com",
      #       "name": "commiter_login"
      #     },
      #     "message": "Commit message",
      #     "distinct": true,
      #     "url": "API commit URL"
      #   }
      # ]
      commits = raw_event['payload']['commits']

      commits.each do |commit|
        commit['author']['email'] = sanitize_email(commit['author']['email'])
      end
    else
      # Do nothing
    end
  end


  # If the email doesn't look to be valid, let's just create a SHA1 of
  # the whole thing. This happens when:
  #   - The email is empty (nil)
  #   - The email field is a string that's not a valid email
  #   - The email doesn't include an '@' symbol
  def sanitize_email(email)
    if email.nil? || email.strip.length < 3 || !email.include?('@')
      return Digest::SHA1.hexdigest(email.to_s)
    else
      prefix, domain = email.strip.split('@')
      # if prefix is an alpha-numeric string of 40 chars: with high
      # confidence it's a SHA1; don't hash it twice
      return email if prefix.match?(/^[a-f0-9]{40}$/i)
      return "#{Digest::SHA1.hexdigest(prefix.to_s)}@#{domain}"
    end
  end
end
