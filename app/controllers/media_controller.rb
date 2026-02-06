class MediaController < ApplicationController
  def index
    @query = params[:query]
    @page = (params[:page] || 1).to_i
    @media_type = params[:type] || "movie"

    if @query.present?
      results = TmdbService.search(@query, @page)
      @titles = results.select do |t|
        (t["media_type"] == "movie" || t["media_type"] == "tv") &&
        t["poster_path"].present? &&
        t["vote_average"].to_f > 0
      end
      @titles = @titles.sort_by { |t| t["vote_average"].to_f }.reverse
    else
      @titles = @media_type == "movie" ? TmdbService.discover_movies(@page) : TmdbService.discover_series(@page)
    end
  end

  def show
    @type = params[:type]
    @id = params[:id]
    @details = TmdbService.fetch_details(@type, @id)
    redirect_to media_path, alert: "Media not found" if @details.nil?
  end
end
