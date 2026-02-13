class PagesController < ApplicationController
  attr_reader :titles

  def about
  end

  def on_the_air
    @page = (params[:page] || 1).to_i
    @titles = TmdbService.on_the_air(@page)
    @media_type = "tv"
  end
end
