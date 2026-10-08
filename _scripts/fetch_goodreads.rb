# Fetches the Goodreads "currently-reading" shelf into _data/currently_reading.json
# so the home page can render it with the site's own styles.
# Never fails the build: on any error it writes an empty list.

require "json"
require "net/http"
require "rexml/document"
require "yaml"

OUT = File.expand_path("../_data/currently_reading.json", __dir__)

def write(books)
  File.write(OUT, JSON.pretty_generate(books))
  puts "goodreads: wrote #{books.size} book(s)"
end

config = YAML.load_file(File.expand_path("../_config.yml", __dir__))
user_id = config.dig("goodreads", "user_id").to_s.strip
if user_id.empty?
  warn "goodreads: no user_id in _config.yml, skipping"
  write([])
  exit
end

begin
  uri = URI("https://www.goodreads.com/review/list_rss/#{user_id}?shelf=currently-reading")
  res = Net::HTTP.get_response(uri)
  raise "HTTP #{res.code}" unless res.is_a?(Net::HTTPSuccess)

  doc = REXML::Document.new(res.body)
  books = doc.get_elements("//item").map do |item|
    text = ->(name) { item.elements[name]&.text.to_s.strip }
    {
      "title" => text.call("title"),
      "author" => text.call("author_name"),
      "url" => "https://www.goodreads.com/book/show/#{text.call('book_id')}"
    }
  end
  write(books)
rescue StandardError => e
  warn "goodreads: fetch failed (#{e.message})"
  write([])
end
