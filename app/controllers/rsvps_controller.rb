class RsvpsController < ApplicationController
  layout 'admin'
  before_action :set_rsvp, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user!, except: [:create]

  # GET /rsvps
  # GET /rsvps.json
  def index
    @rsvps = Rsvp.all
    @total_guest_count = Rsvp.total_guest_count
    @total_not_attending = Rsvp.total_not_attending
  end

  # GET /rsvps/1
  # GET /rsvps/1.json
  def show
  end

  # GET /rsvps/new
  def new
    @rsvp = Rsvp.new(guest_count: 0)
  end

  # GET /rsvps/1/edit
  def edit
  end

  # POST /rsvps
  # POST /rsvps.json
  def create
    @rsvp = Rsvp.new(rsvp_params)
    respond_to do |format|
      if @rsvp.save
        format.html {
          redirect_to root_path, notice: 'RSVPed!'
        }
        format.json { render :show, status: :created, location: @rsvp }
      else
        format.html {
          flash[:warning] = 'There was a problem with your RSVP. Please try again: ' + @rsvp.errors.full_messages.join(', ')
          redirect_to root_path
        }
        format.json { render json: @rsvp.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /rsvps/1
  # PATCH/PUT /rsvps/1.json
  def update
    respond_to do |format|
      if @rsvp.update(rsvp_params)
        format.html { redirect_to @rsvp, notice: 'Rsvp was successfully updated.' }
        format.json { render :show, status: :ok, location: @rsvp }
      else
        format.html { render :edit }
        format.json { render json: @rsvp.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /rsvps/1
  # DELETE /rsvps/1.json
  def destroy
    @rsvp.destroy
    respond_to do |format|
      format.html { redirect_to rsvps_url, notice: 'Rsvp was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_rsvp
      @rsvp = Rsvp.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def rsvp_params
      params.require(:rsvp).permit(:first_name, :last_name, :email, :guest_count, :attending, :song_suggestion)
    end
end
