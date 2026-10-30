# Fetches Goodreads data for the site:
#   _data/currently_reading.json  the "currently-reading" shelf, for the home page
#   _data/reading.json            books and pages per year, for the About page
#
# Goodreads retired its shelf RSS feeds in October 2026, so this reads:
#   - the public bookshelf widget (the embed code Goodreads offers for blogs)
#     for the current shelf, and
#   - the public "Year in Books" pages for the yearly numbers.
# Neither needs a sign-in.
#
# Never fails the build: on any error it writes empty data (which hides the
# panel) and flags a warning on the GitHub Actions run so it doesn't go unnoticed.

require "cgi"
require "date"
require "json"
require "net/http"
require "yaml"

DATA_DIR = File.expand_path("../_data", __dir__)
MAX_BOOKS = 20
MAX_YEARS = 20
RECENT_BOOKS = 5
BAR_WIDTH = 20

def write(file, data, summary)
  File.write(File.join(DATA_DIR, file), JSON.pretty_generate(data))
  puts "goodreads: wrote #{summary}"
end

def flag(message)
  warn "goodreads: #{message}"
  puts "::warning title=Goodreads::#{message}" if ENV["GITHUB_ACTIONS"]
end

def clean(html)
  CGI.unescapeHTML(html.gsub(/<[^>]+>/, "")).gsub(/\s+/, " ").strip
end

def get(uri)
  res = Net::HTTP.get_response(uri)
  raise "HTTP #{res.code} for #{uri.path}" unless res.is_a?(Net::HTTPSuccess)
  res.body.force_encoding("UTF-8")
end

# ------------------------------------------------------------------ shelf

def currently_reading(user_id)
  uri = URI("https://www.goodreads.com/review/custom_widget/#{user_id}.currently-reading")
  # Goodreads caches each widget by widget_id, so each shelf needs its own id.
  uri.query = URI.encode_www_form(shelf: "currently-reading", num_books: MAX_BOOKS,
                                  sort: "date_added", order: "d", show_author: 1, widget_id: 1)

  # The widget is a JavaScript file holding the shelf as an escaped HTML string.
  html = get(uri).gsub('\\"', '"').gsub('\\/', "/").gsub("\\'", "'").gsub('\\n', "\n")
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
  books
end

# ------------------------------------------------------------- yearly stats

def commas(n)
  n.to_s.reverse.scan(/\d{1,3}/).join(",").reverse
end

def number(html, pattern)
  html[pattern, 1].to_s.delete(",").strip.then { |s| s.empty? ? 0 : s.to_i }
end

def year_in_books(user_id, year)
  html = get(URI("https://www.goodreads.com/user/year_in_books/#{year}/#{user_id}"))
  # The count boxes are "heroImageContainer" on recent pages and "headerImageContainer" on older ones.
  label = ->(name) { %r{ImageContainer__count['"]>([\d,]*)</div>\s*<div class=['"]\w+ImageContainer__countLabel['"]>#{name}</div>} }
  raise "unexpected Year in Books format for #{year}" unless html.match?(label.call("books read"))

  # The full list sits in tooltip blocks, oldest first: <img alt="Title by Author">.
  books = html.scan(%r{data-resource-type='Book'>\s*<a href="/book/show/(\d+)[^"]*"><img alt="([^"]*)"}).map do |id, alt|
    title, _, author = CGI.unescapeHTML(alt).rpartition(" by ")
    title = alt if title.empty?
    { "title" => title.strip, "author" => author.strip, "url" => "https://www.goodreads.com/book/show/#{id}" }
  end

  {
    "year" => year,
    "books" => number(html, label.call("books read")),
    "pages" => number(html, label.call("pages read")),
    "avg_pages" => number(html, %r{yyibAverageBookLengthData__pageCount'>\s*([\d,]*)\s*</div>}),
    "list" => books,
    "has_previous" => html.include?("/user/year_in_books/#{year - 1}/#{user_id}")
  }
end

def reading(user_id)
  years = []
  year = Date.today.year
  MAX_YEARS.times do
    y = year_in_books(user_id, year)
    years << y
    break unless y["has_previous"]
    year -= 1
    sleep 0.5 # be gentle with Goodreads
  end

  this_year = years.first
  past = years.select { |y| y["books"].positive? }
  raise "no yearly data found" if past.empty?

  most = past.map { |y| y["books"] }.max
  {
    "year" => this_year["year"],
    "books" => this_year["books"],
    "pages" => this_year["pages"],
    "pages_label" => commas(this_year["pages"]),
    "avg_pages" => this_year["avg_pages"],
    "recent" => this_year["list"].last(RECENT_BOOKS).reverse,
    "total_books" => past.sum { |y| y["books"] },
    "since" => past.last["year"],
    "best" => past.max_by { |y| y["books"] }.slice("year", "books"),
    "years" => past.sort_by { |y| y["year"] }.map do |y|
      filled = [(y["books"].to_f / most * BAR_WIDTH).round, 1].max # every year with books gets a mark
      { "year" => y["year"], "books" => y["books"], "pages" => y["pages"],
        "bar" => ("█" * filled) + ("░" * (BAR_WIDTH - filled)) }
    end
  }
end

# --------------------------------------------------------------------- main

config = YAML.load_file(File.expand_path("../_config.yml", __dir__))
user_id = config.dig("goodreads", "user_id").to_s.strip
if user_id.empty?
  warn "goodreads: no user_id in _config.yml, skipping"
  write("currently_reading.json", [], "no shelf")
  write("reading.json", {}, "no yearly stats")
  exit
end

begin
  books = currently_reading(user_id)
  write("currently_reading.json", books, "#{books.size} book(s) currently reading")
rescue StandardError => e
  flag("currently reading fetch failed (#{e.message})")
  write("currently_reading.json", [], "no shelf")
end

begin
  stats = reading(user_id)
  write("reading.json", stats, "#{stats['years'].size} year(s) of reading, #{stats['books']} book(s) in #{stats['year']}")
rescue StandardError => e
  flag("yearly stats fetch failed (#{e.message})")
  write("reading.json", {}, "no yearly stats")
end
