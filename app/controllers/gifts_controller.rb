class GiftsController < ApplicationController
  # GET /gifts.json
  def index
    wanderable = Wanderable.new(ENV['WANDERABLE_URL'])
    @gifts = wanderable.scrape_gifts

    # Don't render full page layout if this is an AJAX request
    render layout: !request.xhr?
  end
end
