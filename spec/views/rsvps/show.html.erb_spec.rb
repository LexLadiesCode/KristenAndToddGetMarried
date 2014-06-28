require 'rails_helper'

RSpec.describe "rsvps/show", :type => :view do
  before(:each) do
    @rsvp = assign(:rsvp, Rsvp.create!(
      :firstname => "Firstname",
      :lastname => "Lastname",
      :email => "Email",
      :guestcount => 1,
      :attending => false
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/Firstname/)
    expect(rendered).to match(/Lastname/)
    expect(rendered).to match(/Email/)
    expect(rendered).to match(/1/)
    expect(rendered).to match(/false/)
  end
end
