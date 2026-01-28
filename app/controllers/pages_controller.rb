class PagesController < ApplicationController
  attr_reader :titles

  def home
  end

  def about
  end

  def trending
  end

  def media
    @query = params[:query]
    @page = (params[:page] || 1).to_i
    @media_type = params[:type] || "movie"

    if @query.present?
      results = TmdbService.search(@query, @page)

      filtered_titles = results.select do |t|
      (t["media_type"] == "movie" || t["media_type"] == "tv") &&
      t["poster_path"].present? &&
      t["vote_average"].to_f > 0
    end
      @titles = filtered_titles.sort_by { |t| t["vote_average"].to_f }.reverse
      @active_filter = nil
    else
      @titles = @media_type == "movie" ? TmdbService.discover_movies(@page) : TmdbService.discover_series(@page)
      @active_filter = @media_type
    end

    @titles ||= []
  end
end
