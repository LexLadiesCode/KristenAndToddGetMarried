class RsvpMailerPreview < ActionMailer::Preview
  def repondez
    if [true, false].sample
      rsvp = FactoryGirl.create(:rsvp, :attending)
    else
      rsvp = FactoryGirl.create(:rsvp, :not_attending)
    end
    RsvpMailer.repondez(rsvp.id)
  end
end
