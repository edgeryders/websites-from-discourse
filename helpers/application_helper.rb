require 'net/http'
require 'json'
require 'kramdown'

module ApplicationHelper

  def get_discourse_post(args = {})
    api_key = ENV['DISCOURSE_API_KEY']
    id = data.discourse_sources.send(args[:section])
    uri = URI.parse("https://edgeryders.eu/raw/#{id}?api_key=#{api_key}")

    response = Net::HTTP.get_response(uri)

    # Remove HTML comments via gsub(). Otherwise they are rendered as plain text.
    text = response.body.force_encoding("UTF-8").gsub(/<!--.*?-->/m, '')

    # Enable rendering Markdown also when found inside block-level HTML.
    # The standard-compliant "Markdown" parser in Kamdown does not support this, so we have to use "Kramdown".
    options = { input: "Kramdown", parse_block_html: true }
    
    Kramdown::Document.new(text, options).to_html
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
