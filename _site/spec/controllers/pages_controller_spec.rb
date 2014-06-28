require 'rails_helper'

RSpec.describe PagesController, type: :controller do
  describe 'GET index' do
    it 'loads successfully' do
      get :index
      expect(response).to be_success
    end
  end
end
