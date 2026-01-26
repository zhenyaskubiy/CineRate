class PagesController < ApplicationController
  def home
  end

  def about
  end

  def trending
  end

  def media
    @page = (params[:page] || 1).to_i
    @media_type = params[:type] || "movie"

    if @media_type == "movie"
      @titles = TmdbService.discover_movies(@page)
    else
      @titles = TmdbService.discover_series(@page)
    end

    @titles ||= []
  end
end
