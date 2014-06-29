class RsvpMailer < ActionMailer::Base
  DEFAULT_EMAIL = 'rsvp@kristenandtoddgetmarried.com'
  default from: DEFAULT_EMAIL

  def repondez rsvp, recipient
    @rsvp = rsvp
    subject = "New RSVP from #{@rsvp.full_name}!"
    email = @rsvp.email.presence || DEFAULT_EMAIL
    from = name_and_email(@rsvp.full_name, email)
    mail(from: from, to: recipient, subject: subject) do |format|
      format.text
      format.html { render layout: 'email' }
    end
  end

  private

  def name_and_email name, email
    if name.present?
      "#{name} <#{email}>"
    else
      email
    end
  end
end
