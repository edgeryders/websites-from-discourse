require 'net/http'
require 'json'

module ApplicationHelper

  # Markdown renderer with support for Markdown inside HTML block-level elements.
  #
  # Usage: Since Redcarpet does not provide a way to access the renderer from inside Redcarpet::Markdown, as a
  # workaround, we call Redcarpet::Markdown:render() from inside this renderer to enable recursive rendering of Markdown
  # inside HTML. A reference to this method has to be supplied after calling the constructor, like this:
  #
  # renderer = RecursiveRenderer.new()
  # markdown = Redcarpet::Markdown.new(renderer, autolink: true)
  # renderer.set_render &markdown.method(:render)
  #
  # Source: Comment by @pienkowskip at Redcarpet issue #13, see:
  #   https://github.com/vmg/redcarpet/issues/13#issuecomment-43154826
  # Licence: As a contribution to Redcarpet, it is covered by the MIT Licence. See:
  #   See: https://github.com/vmg/redcarpet/blob/master/COPYING
  class RecursiveRenderer < Redcarpet::Render::HTML

    # Override block_html to support parsing nested markdown blocks.
    #
    # @param [String] raw
    def block_html(raw_html)
      if (md = raw_html.match(/\<(.+?)\>(.*)\<(\/.+?)\>/m))
        open_tag, content, close_tag = md.captures
        "\n<#{open_tag}>\n#{render content}<#{close_tag}>\n"
      else
        raw_html
      end
    end

    # Hack to allow using the Markdown renderer recursively by passing in a reference to Redcarpet::Markdown:render()
    #
    # @param [String] markdown
    # @return [String]
    def set_render(&block)
      @render = block
    end

    # Recursively render mixed HTML/Markdown with this renderer.
    #
    # Assumes that @renderer has been properly set to Redcarpet::Markdown:render().
    private
    def render(markdown)
      if @render.nil?
        markdown
      else
        @render.call(markdown)
      end
    end
  end

  # section:
  # locale:
  def get_discourse_post(args = {})
    api_key = ENV['DISCOURSE_API_KEY']
    id = data.discourse_sources.send(args[:section])

    # Use our custom renderer instead of the default Redcarpet::Render::HTML
    renderer = RecursiveRenderer.new()
    markdown = Redcarpet::Markdown.new(renderer, autolink: true)
    renderer.set_render &markdown.method(:render)

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
