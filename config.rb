# Activate and configure extensions
# https://middlemanapp.com/advanced/configuration/#configuring-extensions

activate :autoprefixer do |prefix|
  prefix.browsers = "last 2 versions"
end

# Layouts
# https://middlemanapp.com/basics/layouts/

# Per-page layout changes
#
# With no layout
page '/*.xml', layout: false
page '/*.json', layout: false
page '/*.txt', layout: false

# With alternative layout
# page '/path/to/file.html', layout: 'other_layout'

# Proxy pages
# https://middlemanapp.com/advanced/dynamic-pages/
# proxy "/this-page-has-no-template.html", "/template-file.html", locals: {
#  which_fake_page: "Rendering a fake page with a local variable" }

# Activate and configure blog extension

activate :blog do |blog|
  # This will add a prefix to all links, template references and source paths
  blog.prefix = "blog"

  # blog.permalink = "{year}/{month}/{day}/{title}.html"
  # Matcher for blog source files
  blog.sources = "{year}-{month}-{day}-{title}.html"
  # blog.taglink = "tags/{tag}.html"
  # blog.layout = "layout"
  # blog.summary_separator = /(READMORE)/
  # blog.summary_length = 250
  # blog.year_link = "{year}.html"
  # blog.month_link = "{year}/{month}.html"
  # blog.day_link = "{year}/{month}/{day}.html"
  # blog.default_extension = ".markdown"

  blog.tag_template = "blog/tag.html"
  blog.calendar_template = "blog/calendar.html"

  # Enable pagination
  # blog.paginate = true
  # blog.per_page = 10
  # blog.page_link = "page/{num}"
end

page '/*.xml', layout: false
page '/*.txt', layout: false
# Reload the browser automatically whenever files change
# configure :development do
#   activate :livereload
# end

# Helpers
# Methods defined in the helpers block are available in templates
# https://middlemanapp.com/basics/helper-methods/

# helpers do
#   def some_helper
#     'Helping'
#   end
# end

# Build-specific configuration
# https://middlemanapp.com/advanced/configuration/#environment-specific-settings

configure :build do
  activate :minify_css, inline: true
  activate :minify_javascript, inline: true
  activate :gzip
  activate :minify_html
  activate :imageoptim
end

activate :directory_indexes

events_str = File.read('data/events.json')
events = JSON.parse(events_str)

combined_events = events['upcoming'] + events['past']
combined_events.each do |event|
  if event.key?('shortenedLink')
    shortened_link = event['shortenedLink']
    if !shortened_link.key?('placeholder') || !shortened_link['placeholder'].instance_of?(String) || shortened_link['placeholder'] == ''
      raise Exception.new('Placeholder is missing')
    end

    if !shortened_link.key?('destination') || !shortened_link['destination'].instance_of?(String) || shortened_link['destination'] == ''
      raise Exception.new('Destination is missing')
    end

    proxy "/-/#{shortened_link['placeholder']}/index.html", '/rd/template.html', :locals => { :rd => event }, :ignore => true
  end
end
