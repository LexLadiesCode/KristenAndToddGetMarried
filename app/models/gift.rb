class Gift < ActiveRecord::Base
  # Returns the cost to fund this gift, in dollars.
  def cost
    BigDecimal.new(cost_cents.to_s) / 100
  end

  # Returns the amount of money already received to fund this gift, in dollars.
  def amount_received
    BigDecimal.new(amount_received_cents.to_s) / 100
  end
end
