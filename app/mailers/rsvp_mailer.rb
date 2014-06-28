class RsvpMailer < ActionMailer::Base
  default from: 'rsvp@kristenandtoddgetmarried.com'

  def repondez rsvp_id
    @rsvp = Rsvp.find(rsvp_id)
    subject = "New RSVP from #{@rsvp.name}!"
    from = name_and_email(@rsvp.full_name, @rsvp.email)
    mail(from: from, to: 'cheshire137@gmail.com', subject: subject) do |format|
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
