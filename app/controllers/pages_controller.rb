class PagesController < ApplicationController
  # GET /
  def index
    @gifts = Gift.order(:name)
    @rsvp = Rsvp.new(guest_count: 0)
  end
end
