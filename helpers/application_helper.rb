require 'net/http'
require 'json'

module ApplicationHelper

  # section:
  # locale:
  def get_discourse_post(args={})

    api_key = ENV['DISCOURSE_API_KEY']
    id = data.discourse_sources.send(args[:section]).send(args[:locale])

    uri = URI.parse("https://edgeryders.eu/raw/#{id}?api_key=#{api_key}")
    response = Net::HTTP.get_response(uri)

    markdown = Redcarpet::Markdown.new(Redcarpet::Render::HTML, autolink: true)

    markdown.render(response.body.force_encoding("UTF-8"))
  end


end
