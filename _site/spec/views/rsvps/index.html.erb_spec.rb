require 'rails_helper'

RSpec.describe "rsvps/index", :type => :view do
  before(:each) do
    assign(:rsvps, [
      Rsvp.create!(
        :firstname => "Firstname",
        :lastname => "Lastname",
        :email => "Email",
        :guestcount => 1,
        :attending => false
      ),
      Rsvp.create!(
        :firstname => "Firstname",
        :lastname => "Lastname",
        :email => "Email",
        :guestcount => 1,
        :attending => false
      )
    ])
  end

  it "renders a list of rsvps" do
    render
    assert_select "tr>td", :text => "Firstname".to_s, :count => 2
    assert_select "tr>td", :text => "Lastname".to_s, :count => 2
    assert_select "tr>td", :text => "Email".to_s, :count => 2
    assert_select "tr>td", :text => 1.to_s, :count => 2
    assert_select "tr>td", :text => false.to_s, :count => 2
  end
end
