require 'rails_helper'

RSpec.describe "Rsvps", :type => :request do
  describe "GET /rsvps" do
    it "works! (now write some real specs)" do
      get rsvps_path
      expect(response.status).to be(200)
    end
  end
end
