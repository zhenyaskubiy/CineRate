class TmdbService
  TOKEN = ENV["TMDB_BEARER_TOKEN"]

  def self.authenticate
    require "uri"
    require "net/http"

    url = URI("https://api.themoviedb.org/3/authentication")
    http = Net::HTTP.new(url.host, url.port)
    http.use_ssl = true

    request = Net::HTTP::Get.new(url)
    request["accept"] = "application/json"
    request["Authorization"] = "Bearer #{TOKEN}"

    response = http.request(request)
    JSON.parse(response.read_body)
  end
end
