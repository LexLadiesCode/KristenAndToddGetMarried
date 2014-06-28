require "rails_helper"

RSpec.describe RsvpMailer, type: :mailer do
  describe 'repondez' do
    let(:rsvp) { create(:rsvp) }
    let(:mail) { RsvpMailer.repondez(rsvp.id) }

    it 'renders the headers' do
      expect(mail.subject).to eq('New RSVP from Jane Doe!')
      expect(mail.to).to eq(['to@example.org'])
      expect(mail.from).to eq(['Jane Doe <jane.doe@example.com>'])
    end

    it 'renders the body' do
      expect(mail.body.encoded).to include(rsvp.song_suggestion)
      expect(mail.body.encoded).to include(rsvp.email)
      expect(mail.body.encoded).to include(rsvp.full_name)
      expect(mail.body.encoded).to include("#{rsvp.guest_count} guests")
    end
  end
end
