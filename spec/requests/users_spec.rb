require 'rails_helper'

RSpec.describe 'display likes', type: :request do
  describe '#index' do
    it 'returns a 200 status OK code' do
      get '/'
      expect(response.code).to eq '200'
    end
  end

  describe '#show' do
    let(:user) { FactoryBot.create(:user) }

    it 'returns a 200 status OK code' do
      get "/users/#{user.id}"
      expect(response.code).to eq '200'
    end
  end
end
