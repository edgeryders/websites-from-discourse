require 'net/http'
require 'json'

module ApplicationHelper

  # section:
  # locale:
  def get_discourse_post(args = {})
    api_key = ENV['DISCOURSE_API_KEY']
    id = data.discourse_sources.send(args[:section]).send(args[:locale])
    markdown = Redcarpet::Markdown.new(Redcarpet::Render::HTML, autolink: true)

    uri = URI.parse("https://edgeryders.eu/raw/#{id}?api_key=#{api_key}")
    response = Net::HTTP.get_response(uri)
    # NOTE: gsub removes HTML comments. Otherwise they are rendered as plain text.
    text = response.body.force_encoding("UTF-8").gsub(/<!--.*?-->/m, '')
    markdown.render(text)
  end

  # See https://edgeryders.eu/c/ioh.json for the available attributes.
  def get_most_recent_topics
    get_json_data('https://edgeryders.eu/c/ioh.json')
  end

  # See https://edgeryders.eu/tags/c/ioh/events/event.json for the available attributes.
  def get_event_topics
    get_json_data('https://edgeryders.eu/c/ioh/events/l/agenda.json')
  end

  def get_tell_your_story_topics
    get_json_data('https://edgeryders.eu/c/ioh.json')
  end

  def get_tell_your_story_stats
    page = 0
    stats = OpenStruct.new(user_count: 0, topic_count: 0, comment_count: 0)
    user_ids = []
    loop do
      results = get_json_data("https://edgeryders.eu/c/ioh.json?page=#{page}")
      if results['users'].present?
        user_ids += results['users'].map {|u| u['id']}
        stats.topic_count += results['topic_list']['topics'].count
        stats.comment_count += results['topic_list']['topics'].sum {|t| t['posts_count'] -1 }
        page += 1
      else
        break
      end
    end
    stats.user_count = user_ids.uniq.count
    stats
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
