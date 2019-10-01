require 'net/http'
require 'json'
require 'kramdown'
require 'json-schema'

module ApplicationHelper

  # Get raw post content from Discourse via API.
  # 
  # @param args [Hash] Either use the "section" and "locale" hash keys or the "topic_id" and 
  #   "post_id" has keys. You can all this just like with named parameters, as Ruby will convert 
  #   it to a hash automatically: `get_discourse_raw_post(topic_id: 123, post_id: 1)`.
  def get_discourse_raw_post(args = {})
    api_key = ENV['DISCOURSE_API_KEY']
    topic_id = args[:topic_id]
    post_id = args[:post_id]
    uri = URI.parse("https://edgeryders.eu/raw/#{topic_id}/#{post_id}?api_key=#{api_key}")

    response = Net::HTTP.get_response(uri)

    text = response.body.force_encoding("UTF-8")
  end

  # Get the content of a Discourse post and render it to HTML.
  #
  # @param args [Hash] Either use the "section" and "locale" hash keys or the "topic_id" and 
  #   "post_id" has keys. You can all this just like with named parameters, as Ruby will convert 
  #   it to a hash automatically: `get_discourse_raw_post(topic_id: 123, post_id: 1)`.
  def get_discourse_html_post(args = {})
    if (args.key?(:section))
      topic_id, post_id = data.discourse_sources.send(args[:section]).send(args[:locale])
    else
      topic_id, post_id = args[:topic_id], args[:post_id]
    end

    raw_post = get_discourse_raw_post(topic_id: topic_id, post_id: post_id,)
    
    # Remove HTML comments via gsub(). Otherwise they are rendered as visible text in the output.
    # TODO At least that's what happened with Redcarpet. Now we use Kramdown as Markdown processor. Test again.
    raw_post = raw_post.gsub(/<!--.*?-->/m, '')

    # Enable rendering Markdown also when found inside block-level HTML.
    # The standard-compliant "Markdown" parser in Kamdown does not support this, so we have to use "Kramdown".
    options = { input: "Kramdown", parse_block_html: true }

    Kramdown::Document.new(raw_post, options).to_html
  end

  # Get post content from Discourse and extract the valid JSON from it.
  # 
  # @param args [Hash] Either use the "section" and "locale" hash keys or the "topic_id" and 
  #   "post_id" has keys. You can all this just like with named parameters, as Ruby will convert 
  #   it to a hash automatically: `get_discourse_raw_post(topic_id: 123, post_id: 1)`.
  #
  # @todo If the whole raw post is valid JSON, use that. Only otherwise look for code fences.
  # @todo When extracting JSON from code fences, collect everything behind ```json and let a 
  #   JSON parser consume as much as it can until encountering a syntax error. Otherwise, ```
  #   inside JSON content would be interpreted as a code fence.
  def get_discourse_json_post(args = {})
    if (args.key?(:section))
      topic_id, post_id = data.discourse_sources.send(args[:section]).send(args[:locale])
    else
      topic_id, post_id = args[:topic_id], args[:post_id]
    end

    raw_post = get_discourse_raw_post(topic_id: args[:topic_id], post_id: args[:post_id])

    # Extract the content of the first code-fenced JSON code block.
    # (*? is a non-greedy * match, stopping at first ```; /m option makes * cover \n)
    if match = raw_post.match(/```json(.*?)```/m)
      match[1]
    end
  end

  # Get and return team member data from Discourse.
  # 
  # @return [Array] Array of hashes, one hash per teammember. All hashed are guaranteed to have 
  #   these keys: `name`, `role`, `username`, `email`, `description`, `photo_url`.
  #
  # @todo Require "name" and "photo_url" to have non-empty values.
  # @todo If validating the full JSON data fails, try to extract and return many team member 
  #   records as possible that validate properly.
  def get_team()
    team_schema = {
      "type" => "object",
      "required" => ["name", "role", "username", "email", "description", "photo_url"],
      "properties" => {
        "name" => {"type" => "string"},
        "role" => {"type" => "string"},
        "username" => {"type" => "string"},
        "email" => {"type" => "string"},
        "description" => {"type" => "string"},
        "photo_url" => {"type" => "string"}
      }
    }
    
    team_json = get_discourse_json_post(topic_id: 10892, post_id: 1) 
    
    begin
      JSON::Validator.validate!(team_schema, team_json)
    rescue JSON::Schema::ValidationError => e
      e.message
    end
    
    JSON.parse(team_json)
  end

    

  def get_json_data(url)
    uri = URI.parse(url)
    response = Net::HTTP.get_response(uri)
    JSON.parse(response.body.force_encoding("UTF-8"))
  end

  # Source: https://github.com/middleman/middleman/issues/1490
  def i18n_path(path, options = {})
    lang = options[:language] ? options[:language] : I18n.locale.to_s
    # English is mounted at root
    lang = '' if lang == 'en'
    # Replace multiple slashes with one
    "/#{lang}/#{path}".gsub(/\/+/, '/')
  end

end
