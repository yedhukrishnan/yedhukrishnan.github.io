# Fetches GitHub stats and the contribution calendar into _data/github.json
# so the About page can render them with the site's own styles.
# Needs a token in GITHUB_TOKEN (the Actions token works; locally use `gh auth token`).
# Never fails the build: on any error it writes an empty object.

require "json"
require "net/http"
require "yaml"
require "date"

OUT = File.expand_path("../_data/github.json", __dir__)
BAR_WIDTH = 20

def write(data)
  File.write(OUT, JSON.pretty_generate(data))
  puts "github: wrote #{data.empty? ? 'empty data' : "#{data['total']} contributions"}"
end

QUERY = <<~GQL
  query($login: String!) {
    user(login: $login) {
      followers { totalCount }
      repositories(ownerAffiliations: OWNER, privacy: PUBLIC, isFork: false, first: 100) {
        totalCount
        nodes {
          stargazerCount
          languages(first: 10, orderBy: { field: SIZE, direction: DESC }) {
            edges { size node { name } }
          }
        }
      }
      contributionsCollection {
        contributionCalendar {
          totalContributions
          weeks { contributionDays { date contributionCount contributionLevel } }
        }
      }
    }
  }
GQL

LEVELS = {
  "NONE" => 0, "FIRST_QUARTILE" => 1, "SECOND_QUARTILE" => 2,
  "THIRD_QUARTILE" => 3, "FOURTH_QUARTILE" => 4
}.freeze

def streaks(days)
  longest = run = 0
  days.each do |d|
    run = d["count"].positive? ? run + 1 : 0
    longest = run if run > longest
  end
  # Today may have no contributions yet, so don't let it break the current streak.
  tail = days.dup
  tail.pop if tail.any? && tail.last["count"].zero?
  current = tail.reverse.take_while { |d| d["count"].positive? }.size
  [current, longest]
end

config = YAML.load_file(File.expand_path("../_config.yml", __dir__))
login = config["github_username"].to_s.strip
token = ENV["GITHUB_TOKEN"].to_s.strip
if login.empty? || token.empty?
  warn "github: missing github_username or GITHUB_TOKEN, skipping"
  write({})
  exit
end

begin
  uri = URI("https://api.github.com/graphql")
  req = Net::HTTP::Post.new(uri, "Authorization" => "bearer #{token}", "Content-Type" => "application/json")
  req.body = JSON.generate(query: QUERY, variables: { login: login })
  res = Net::HTTP.start(uri.host, uri.port, use_ssl: true) { |http| http.request(req) }
  raise "HTTP #{res.code}" unless res.is_a?(Net::HTTPSuccess)

  body = JSON.parse(res.body)
  raise body["errors"].map { |e| e["message"] }.join("; ") if body["errors"]
  user = body.dig("data", "user") or raise "user not found"

  calendar = user["contributionsCollection"]["contributionCalendar"]
  weeks = calendar["weeks"].map do |w|
    w["contributionDays"].map do |d|
      { "date" => d["date"], "count" => d["contributionCount"], "level" => LEVELS.fetch(d["contributionLevel"], 0),
        "weekday" => Date.parse(d["date"]).wday }
    end
  end
  days = weeks.flatten

  # A month label sits above the first week that starts in that month.
  months = []
  weeks.each_with_index do |w, i|
    month = Date.parse(w.first["date"]).strftime("%b")
    next if months.any? && months.last["label"] == month
    months << { "x" => i, "label" => month }
  end
  months.shift if months.size > 1 && months[1]["x"] - months[0]["x"] < 3 # avoid overlapping labels

  repos = user["repositories"]
  sizes = Hash.new(0)
  repos["nodes"].each do |r|
    r["languages"]["edges"].each { |e| sizes[e["node"]["name"]] += e["size"] }
  end
  total_size = sizes.values.sum
  languages = sizes.sort_by { |_, s| -s }.first(5).map do |name, size|
    pct = total_size.zero? ? 0 : (100.0 * size / total_size)
    filled = (pct / 100 * BAR_WIDTH).round
    { "name" => name, "percent" => pct.round, "bar" => ("█" * filled) + ("░" * (BAR_WIDTH - filled)) }
  end

  current, longest = streaks(days)
  best = days.max_by { |d| d["count"] }

  write({
    "total" => calendar["totalContributions"],
    "from" => days.first["date"],
    "to" => days.last["date"],
    "repos" => repos["totalCount"],
    "stars" => repos["nodes"].sum { |r| r["stargazerCount"] },
    "followers" => user["followers"]["totalCount"],
    "current_streak" => current,
    "longest_streak" => longest,
    "best_day" => best && { "date" => best["date"], "count" => best["count"] },
    "languages" => languages,
    "months" => months,
    "weeks" => weeks
  })
rescue StandardError => e
  warn "github: fetch failed (#{e.message})"
  write({})
end
