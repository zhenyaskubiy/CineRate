require "uri"
require "net/http"
require "json"

class TmdbService
  BASE_URL = "https://api.themoviedb.org/3"
  TOKEN = ENV["TMDB_BEARER_TOKEN"]

  def self.authenticate
    get_request("/authentication")
  end

  def self.search(query, page = 1)
    return [] if query.blank?
    get_request("/search/multi?query=#{URI.encode_www_form_component(query)}&page=#{page}")["results"] || []
  end

  def self.popular_movies
    get_request("/movie/popular")["results"] || []
  end

  def self.discover_movies(page = 1)
    get_request("/discover/movie?page=#{page}")["results"] || []
  end

  def self.discover_series(page = 1)
    get_request("/discover/tv?page=#{page}")["results"] || []
  end

  private

  def self.get_request(endpoint)
    url = URI("#{BASE_URL}#{endpoint}")
    http = Net::HTTP.new(url.host, url.port)
    http.use_ssl = true

    request = Net::HTTP::Get.new(url)
    request["accept"] = "application/json"
    request["Authorization"] = "Bearer #{TOKEN}"

    response = http.request(request)

    if response.is_a?(Net::HTTPSuccess)
      JSON.parse(response.read_body)
    else
      { "error" => "API request failed", "code" => response.code }
    end
  rescue StandardError => e
    { "error" => e.message }
  end
end
