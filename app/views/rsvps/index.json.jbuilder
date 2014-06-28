json.array!(@rsvps) do |rsvp|
  json.extract! rsvp, :id, :firstname, :lastname, :email, :guestcount, :attending
  json.url rsvp_url(rsvp, format: :json)
end
