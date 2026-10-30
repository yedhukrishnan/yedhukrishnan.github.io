# Fetches the Goodreads "currently-reading" shelf into _data/currently_reading.json
# so the home page can render it with the site's own styles.
#
# Goodreads retired its shelf RSS feeds in October 2026, so this reads the
# public bookshelf widget instead (the embed code Goodreads offers for blogs).
# It needs no sign-in and lists up to num_books books from the shelf.
#
# Never fails the build: on any error it writes an empty list (which hides the
# panel) and flags a warning on the GitHub Actions run so it doesn't go unnoticed.

require "cgi"
require "json"
require "net/http"
require "yaml"

OUT = File.expand_path("../_data/currently_reading.json", __dir__)
MAX_BOOKS = 20

def write(books)
  File.write(OUT, JSON.pretty_generate(books))
  puts "goodreads: wrote #{books.size} book(s)"
end

def fail_soft(message)
  warn "goodreads: #{message}"
  puts "::warning title=Goodreads::#{message}" if ENV["GITHUB_ACTIONS"]
  write([])
end

def clean(html)
  CGI.unescapeHTML(html.gsub(/<[^>]+>/, "")).gsub(/\s+/, " ").strip
end

config = YAML.load_file(File.expand_path("../_config.yml", __dir__))
user_id = config.dig("goodreads", "user_id").to_s.strip
if user_id.empty?
  warn "goodreads: no user_id in _config.yml, skipping"
  write([])
  exit
end

begin
  uri = URI("https://www.goodreads.com/review/custom_widget/#{user_id}.currently-reading")
  uri.query = URI.encode_www_form(shelf: "currently-reading", num_books: MAX_BOOKS,
                                  sort: "date_added", order: "d", show_author: 1, widget_id: 1)
  res = Net::HTTP.get_response(uri)
  raise "HTTP #{res.code}" unless res.is_a?(Net::HTTPSuccess)

  # The widget is a JavaScript file holding the shelf as an escaped HTML string.
  html = res.body.force_encoding("UTF-8").gsub('\\"', '"').gsub('\\/', "/").gsub("\\'", "'").gsub('\\n', "\n")
  raise "unexpected widget format" unless html.include?("gr_custom_each_container")

  books = html.split(/<div class="gr_custom_each_container_\d+">/).drop(1).filter_map do |entry|
    title = entry[/class="gr_custom_title_\d+">\s*<a[^>]*>(.*?)<\/a>/m, 1]
    next unless title

    author = entry[/class="gr_custom_author_\d+">.*?<a[^>]*>(.*?)<\/a>/m, 1].to_s
    # The cover image is named after the book id; fall back to the review link.
    book_id = entry[%r{/books/\d+\w?/(\d+)\.}, 1]
    url = if book_id
            "https://www.goodreads.com/book/show/#{book_id}"
          else
            entry[/class="gr_custom_title_\d+">\s*<a[^>]*href="([^"?]+)/m, 1].to_s
          end
    { "title" => clean(title), "author" => clean(author), "url" => url }
  end

  # An empty shelf and a changed widget look the same, so treat both as worth a look.
  raise "no books found in the widget" if books.empty?

  write(books)
rescue StandardError => e
  fail_soft("fetch failed (#{e.message})")
end
