class PagesController < ApplicationController
  # GET /
  def index
  end

  # GET /wander
  def wander
    wanderable = Wanderable.new(ENV['WANDERABLE_URL'])
    render json: wanderable.get_data
  end
end
