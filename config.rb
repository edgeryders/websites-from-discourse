require 'active_support/all'

activate :directory_indexes

set :css_dir, 'assets/css'
set :js_dir, 'assets/js'
set :images_dir, 'assets/images'

page '/*.xml', layout: false
page '/*.json', layout: false
page '/*.txt', layout: false

activate :external_pipeline,
  name: :webpack,
  command: build? ? 'npm run build' : 'npm run watch',
  source: ".tmp/dist",
  latency: 1

configure :development do
  activate :livereload do |reload|
    reload.no_swf = true
  end
end

configure :production do
  activate :minify_html
  activate :asset_hash, ignore: [/\.jpg\Z/, /\.png\Z/, /\.svg\Z/]
end

activate :i18n do |i18n|
  i18n.locales =  %w[en de fr it pl]
end

# Uses .env in the root of the project
activate :dotenv