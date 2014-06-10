class Wanderable
  attr_reader :agent, :url

  def initialize url
    @agent = Mechanize.new {|agent| agent.user_agent_alias = 'Mac Safari' }
    @url = url
  end

  def get_data
    data = []
    @agent.get(@url) do |page|
      list = page.at('#hm-list')
      list.search('.details').each do |gift|
        name = gift.at('h2').text
        details = gift.search('p').map {|p| p.text }.reject {|txt| txt.blank? }
        case details.size
        when 2
          description, location = details
        when 1
          location = details.first
        else
          description = details.join("\n").presence
        end
        data << {name: name, description: description, location: location}
      end
    end
    data
  end
end
