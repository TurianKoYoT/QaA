class SearchController < ApplicationController
  authorize_resource

  def index
    @query = params[:query]
    @location = params[:location]
    @results = Search.find(@query, @location)
  end
end
