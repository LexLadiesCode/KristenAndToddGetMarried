class GiftsController < ApplicationController
  # GET /gifts.json
  def index
    wanderable = Wanderable.new(ENV['WANDERABLE_URL'])
    @gifts = wanderable.scrape_gifts
  end
end
