class GiftsController < ApplicationController
  # GET /gifts.json
  def index
    wanderable = Wanderable.new(ENV['WANDERABLE_URL'])
    wanderable.scrape_gifts
    @gifts = Gift.order(:name)

    # Don't render full page layout if this is an AJAX request
    render layout: !request.xhr?
  end
end
