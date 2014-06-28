class PagesController < ApplicationController
  # GET /
  def index
    @gifts = Gift.order(:name)
    @rsvp = Rsvp.new
  end
end
