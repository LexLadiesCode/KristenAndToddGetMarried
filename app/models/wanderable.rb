class Wanderable
  attr_reader :agent, :url

  def initialize url
    @agent = Mechanize.new do |agent|
      agent.user_agent_alias = 'Mac Safari'
      agent.max_history = 0
      agent.keep_alive = false
      agent.ssl_version = 'SSLv3'
      agent.verify_mode = OpenSSL::SSL::VERIFY_NONE
    end
    @url = url
  end

  def scrape_gifts
    page = @agent.get(@url)
    page.at('#hm-list').search('.hm-panel .item').each do |gift_html|
      extract_gift(gift_html)
    end
  end

  private

  def extract_gift gift_html
    image_url = gift_html.at('.col-sm-8 img')['src']
    name = gift_html.at('.details h2').text
    details = gift_html.search('.details p').map {|p| p.text }.
                                        reject {|txt| txt.blank? }
    case details.size
    when 2
      description, location = details
    when 1
      location = details.first
    else
      description = details.join("\n").presence
    end
    cost_str = gift_html.at('.col-sm-4 p').text
    relative_url = gift_html.at('.col-sm-4 a.add_to_cart')['href']
    unless relative_url.start_with?('http')
      url = Gift::URL_PREFIX + relative_url
    end
    gift = Gift.where(url: url).first_or_initialize
    gift.name = name
    gift.description = description
    gift.location = location
    gift.image_url = image_url
    gift.url = url
    if cost_str.present?
      dollars = BigDecimal.new(Monetize.parse(cost_str).to_s)
      cents_remaining = (dollars * 100).to_i
      if total_cents=Gift.total_cost_for_url(relative_url)
        gift.cost_cents = total_cents
        gift.amount_received_cents = total_cents - cents_remaining
      end
    end
    gift.save
  end
end
