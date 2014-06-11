class Wanderable
  attr_reader :agent, :url

  def initialize url
    @agent = Mechanize.new {|agent| agent.user_agent_alias = 'Mac Safari' }
    @url = url
  end

  def scrape_gifts
    gifts = []
    @agent.get(@url) do |page|
      page.at('#hm-list').search('.hm-panel .item').each do |gift_html|
        gifts << extract_gift(gift_html)
      end
    end
    gifts
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
    url = gift_html.at('.col-sm-4 a.add_to_cart')['href']
    url = 'https://wanderable.com' + url unless url.start_with?('http')
    gift = Gift.where(name: name).first_or_initialize
    gift.description = description
    gift.location = location
    gift.image_url = image_url
    gift.url = url
    if cost_str.present?
      dollars = BigDecimal.new(Monetize.parse(cost_str).to_s)
      gift.cost_cents = (dollars * 100).to_i
    end
    # TODO: set amount_received_cents on gift
    # gift.amount_received_cents = ???
    gift.save
    gift
  end
end
