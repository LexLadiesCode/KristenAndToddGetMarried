require "rails_helper"

RSpec.describe RsvpsController, :type => :routing do
  describe "routing" do

    it "routes to #index" do
      expect(:get => "/rsvps").to route_to("rsvps#index")
    end

    it "routes to #new" do
      expect(:get => "/rsvps/new").to route_to("rsvps#new")
    end

    it "routes to #show" do
      expect(:get => "/rsvps/1").to route_to("rsvps#show", :id => "1")
    end

    it "routes to #edit" do
      expect(:get => "/rsvps/1/edit").to route_to("rsvps#edit", :id => "1")
    end

    it "routes to #create" do
      expect(:post => "/rsvps").to route_to("rsvps#create")
    end

    it "routes to #update" do
      expect(:put => "/rsvps/1").to route_to("rsvps#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/rsvps/1").to route_to("rsvps#destroy", :id => "1")
    end

  end
end
