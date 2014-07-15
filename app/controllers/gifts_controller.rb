class GiftsController < ApplicationController
  # GET /gifts.json
  def index
    wanderable = Wanderable.new(ENV['WANDERABLE_URL'])
    wanderable.scrape_gifts
    @gifts = Gift.order(:name)
    respond_to do |format|
      # Don't render full page layout if this is an AJAX request
      format.html { render layout: !request.xhr? }
      format.json
    end
  end
end
