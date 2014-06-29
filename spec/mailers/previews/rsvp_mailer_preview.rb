class RsvpMailerPreview < ActionMailer::Preview
  def repondez
    if [true, false].sample
      rsvp = FactoryGirl.build(:rsvp, :attending)
    else
      rsvp = FactoryGirl.build(:rsvp, :not_attending)
    end
    RsvpMailer.repondez(rsvp, 'test@example.com')
  end
end
