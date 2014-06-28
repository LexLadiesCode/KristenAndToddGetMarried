require 'rails_helper'

RSpec.describe GiftsController, type: :controller do
  describe 'GET index', vcr: relative_cassette('gift_scrape') do
    it 'loads successfully' do
      get :index
      expect(response).to be_success
    end

    it 'creates new gifts' do
      expect { get :index }.to change(Gift, :count).by(3)
    end

    it 'updates existing gift based on name' do
      gift = Gift.create!(name: 'Scuba diving', cost_cents: 18000)
      get :index
      expect(gift.reload.location).to eq('Nifty Location')
    end

    it 'sets names on new gifts' do
      get :index
      expect(Gift.all.map(&:name)).to eq(['5 night stay', 'Airfare',
                                          'Scuba diving'])
    end

    it 'sets costs on new gifts' do
      get :index
      expect(Gift.all.map(&:cost_cents)).to eq([3000_00, 2500_00, 180_00])
    end

    it 'sets locations on new gifts' do
      get :index
      expect(Gift.all.map(&:location)).to eq(['Some Cool Place', nil,
                                              'Nifty Location'])
    end
  end
end
