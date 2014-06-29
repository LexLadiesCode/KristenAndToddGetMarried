class Rsvp < ActiveRecord::Base
  after_create :send_email

  def full_name
    "#{first_name} #{last_name}".strip
  end

  def send_email
    RsvpMailer.repondez(self).deliver
  end
end
