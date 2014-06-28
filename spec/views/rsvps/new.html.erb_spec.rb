require 'rails_helper'

RSpec.describe "rsvps/new", :type => :view do
  before(:each) do
    assign(:rsvp, Rsvp.new(
      :firstname => "MyString",
      :lastname => "MyString",
      :email => "MyString",
      :guestcount => 1,
      :attending => false
    ))
  end

  it "renders new rsvp form" do
    render

    assert_select "form[action=?][method=?]", rsvps_path, "post" do

      assert_select "input#rsvp_firstname[name=?]", "rsvp[firstname]"

      assert_select "input#rsvp_lastname[name=?]", "rsvp[lastname]"

      assert_select "input#rsvp_email[name=?]", "rsvp[email]"

      assert_select "input#rsvp_guestcount[name=?]", "rsvp[guestcount]"

      assert_select "input#rsvp_attending[name=?]", "rsvp[attending]"
    end
  end
end
