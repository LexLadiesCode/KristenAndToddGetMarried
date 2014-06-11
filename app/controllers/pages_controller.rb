class PagesController < ApplicationController
  # GET /
  def index
    @gifts = Gift.order(:name)
  end
end
