class Rsvp < ActiveRecord::Base
  after_create :send_emails

  scope :attending, ->{ where(attending: true) }

  scope :not_attending, ->{ where(attending: false) }

  validates :first_name, presence: true
  validates :guest_count, presence: true,
                          numericality: {only_integer: true, greater_than: -1}
  validate :not_attending_zero_guest_count

  def self.total_guest_count
    attending.pluck(:guest_count).sum
  end

  def self.total_not_attending
    not_attending.count
  end

  def full_name
    "#{first_name} #{last_name}".strip
  end

  def send_emails
    User.all.each do |user|
      RsvpMailer.repondez(self, user.email).deliver
    end
  end

  private

  def not_attending_zero_guest_count
    if guest_count && guest_count.nonzero? && !attending
      errors.add(:guest_count, 'must be zero if you are not attending.')
    end
  end
end
