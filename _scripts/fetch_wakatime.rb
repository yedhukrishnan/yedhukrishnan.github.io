# Fetches WakaTime share charts (languages, editors, ...) into
# _data/wakatime.json so the About page can render them with the site's own
# styles. No token needed: the share links under `wakatime:` in _config.yml
# are public. Never fails the build: a chart that can't be fetched is left out.

require "json"
require "net/http"
require "yaml"

OUT = File.expand_path("../_data/wakatime.json", __dir__)
BAR_WIDTH = 20
MAX_ROWS = 8
OTHER_COLOR = "#6b7385"

def row(name, pct, color)
  filled = (pct / 100 * BAR_WIDTH).round
  { "name" => name, "percent" => pct.round(1), "color" => color || OTHER_COLOR,
    "bar" => ("█" * filled) + ("░" * (BAR_WIDTH - filled)) }
end

def fetch_chart(url, hidden)
  res = Net::HTTP.get_response(URI(url))
  raise "HTTP #{res.code}" unless res.is_a?(Net::HTTPSuccess)

  rows = JSON.parse(res.body)["data"] or raise "no data"
  rows = rows.sort_by { |r| -r["percent"].to_f }

  # Hidden names and the tail are folded into "Other", so percentages stay true.
  top = rows.reject { |r| r["name"] == "Other" || hidden.include?(r["name"].to_s.downcase) }.first(MAX_ROWS)
  out = top.map { |r| row(r["name"], r["percent"].to_f, r["color"]) }
  rest = 100.0 - top.sum { |r| r["percent"].to_f }
  out << row("Other", rest, OTHER_COLOR) if rest >= 0.1
  raise "empty" if out.empty?
  out
end

config = YAML.load_file(File.expand_path("../_config.yml", __dir__))
charts = config["wakatime"].is_a?(Hash) ? config["wakatime"].dup : {}
hidden = Array(charts.delete("hide")).map { |n| n.to_s.strip.downcase }

data = {}
charts.each do |name, url|
  next if url.to_s.strip.empty?
  data[name] = fetch_chart(url.to_s.strip, hidden)
rescue StandardError => e
  warn "wakatime: #{name} fetch failed (#{e.message})"
end

File.write(OUT, JSON.pretty_generate(data))
puts "wakatime: wrote #{data.empty? ? 'empty data' : data.map { |k, v| "#{v.size} #{k}" }.join(', ')}"
