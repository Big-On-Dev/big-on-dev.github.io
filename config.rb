# Activate and configure extensions
# https://middlemanapp.com/advanced/configuration/#configuring-extensions

activate :autoprefixer do |prefix|
  prefix.browsers = "last 2 versions"
end

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

    rd_payload = {
      'title' => event['title'],
      'description' => event['description'],
      'redirect_url' => event['shortenedLink']['destination']
    }

    proxy "/-/#{shortened_link['placeholder']}/index.html", '/rd/template.html', :locals => { :rd => rd_payload }, :ignore => true
  end
end

links_str = File.read('data/shortened_links.json')
links_hash = JSON.parse(links_str)
links_hash.each do |key, value|
  puts "#{key} #{value}"
  rd_payload = {
    'title' => 'Redirect',
    'description' => 'Redirecting...',
    'redirect_url' => value
  }

  proxy "/-/#{key}/index.html", '/rd/template.html', :locals => { :rd => rd_payload }, :ignore => true
end
