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
    uri = URI.parse("https://edgeryders.eu/c/ioh.json")
    response = Net::HTTP.get_response(uri)
    JSON.parse(response.body.force_encoding("UTF-8"))
  end

  def get_tell_your_story_topics
    uri = URI.parse("https://edgeryders.eu/c/ioh/tell-your-story.json")
    response = Net::HTTP.get_response(uri)
    JSON.parse(response.body.force_encoding("UTF-8"))
  end

  # See https://edgeryders.eu/tags/c/ioh/events/event.json for the available attributes.
  def get_event_topics
    uri = URI.parse("https://edgeryders.eu/c/ioh/events/l/agenda.json")
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
