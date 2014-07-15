class Gift < ActiveRecord::Base
  validates :name, presence: true
  validates :cost_cents, presence: true
  validates :url, presence: true, uniqueness: true

  URL_PREFIX = 'https://wanderable.com'.freeze

  TOTAL_COST_CENTS = {
    '/cart/86296/add?item_id=86296' => 3000_00,
    '/cart/86305/add?item_id=86305' => 2500_00,
    '/cart/86291/add?item_id=86291' => 180_00,
    '/cart/86279/add?item_id=86279' => 250_00,
    '/cart/86292/add?item_id=86292' => 240_00,
    '/cart/86301/add?item_id=86301' => 400_00,
    '/cart/86293/add?item_id=86293' => 205_00,
    '/cart/86295/add?item_id=86295' => 780_00
  }.freeze

  def self.total_cost_for_url url
    TOTAL_COST_CENTS.each do |url_stub, cost_in_cents|
      if url.include?(url_stub)
        return cost_in_cents
      end
    end
  end

  # Returns the cost to fund this gift, in dollars.
  def cost
    return unless cost_cents
    BigDecimal.new(cost_cents.to_s) / 100
  end

  # Returns the amount remaining to fully fund this gift, in dollars.
  def amount_remaining
    return unless cost_cents && amount_received_cents
    remaining_cents = cost_cents - amount_received_cents
    BigDecimal.new(remaining_cents.to_s) / 100
  end

  # Returns the amount of money already received to fund this gift, in dollars.
  def amount_received
    return unless amount_received_cents
    BigDecimal.new(amount_received_cents.to_s) / 100
  end

  def unfunded?
    amount_received_cents.nil? || amount_received_cents.zero?
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
