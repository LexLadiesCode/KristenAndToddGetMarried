class Gift < ActiveRecord::Base
  validates :name, presence: true
  validates :cost_cents, presence: true

  # Returns the cost to fund this gift, in dollars.
  def cost
    return unless cost_cents
    BigDecimal.new(cost_cents.to_s) / 100
  end

  # Returns the amount of money already received to fund this gift, in dollars.
  def amount_received
    return unless amount_received_cents
    BigDecimal.new(amount_received_cents.to_s) / 100
  end

  # Returns a value between 0-100 representing how fully this gift is funded.
  def percent_funded
    if amount_received_cents
      ratio = BigDecimal.new(amount_received_cents.to_s) / cost_cents
      (ratio * 100).to_i
    else
      0
    end
  end
end
