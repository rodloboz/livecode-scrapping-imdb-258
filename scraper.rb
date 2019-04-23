require "open-uri"
require "nokogiri"
require "byebug"

# fetch_movie_urls
# Visit/open 'chart/top'
# Target anchor tag inside class 'titleColumn'
# Take 5 of those
# Return an array of links/urls
BASE_URL = "http://www.imdb.com"

def parse_url(url)
  html_file = open(url).read
  Nokogiri::HTML(html_file)
end


def fetch_movie_urls
  url = BASE_URL + "/chart/top"
  html_doc = parse_url(url)
  links = []
  html_doc.search(".titleColumn a").first(5).each do |element|
   links << BASE_URL + element.attributes["href"].value
 end
 return links
end

fetch_movie_urls

# scrape_movie
# Visit movie page/url
# Target h1 and get title and year
# Target summary_text class and get storyline
# Target credit_summary_item
# Get the director from the anchor in the first element
# Target the anchors inside the last element
# and get the cast names
# return movie hash

def scrape_movie(url)
  html_doc = parse_url(url)

  pattern = /^(?<title>.+)[[:space:]]\((?<year>\d{4})\)$/

  match_data = html_doc.search("h1").text.strip.match(pattern)
  title = match_data[:title]
  year = match_data[:year].to_i
  storyline = html_doc.search(".summary_text").text.strip
  director = html_doc.search(".credit_summary_item a").first.text

  cast_div = html_doc.search(".credit_summary_item")

  # cast = []
  # cast_div.last.search("a").take(3).each do |element|
  #   cast << element.text
  # end

  cast = cast_div.last.search("a").take(3).map do |element|
    element.text
  end

  {
    title: title,
    year: year,
    storyline: storyline,
    director: director,
    cast: cast
  }
end

url = "http://www.imdb.com/title/tt0468569/"
scrape_movie(url)




