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

  describe '#destroy' do
    let(:user) { FactoryBot.create(:user) }

    context 'when signed in as an admin' do
      let(:admin) { FactoryBot.create(:admin) }

      before do
        sign_in admin
        delete "/users/delete/#{user.id}"
      end

      it 'deletes the record from the database' do
        expect(User.count).to eq 0
      end

      it 'redirects to the home page' do
        expect(response).to redirect_to root_path
      end
    end

    context 'when not signed in as an admin' do
      before { delete "/users/delete/#{user.id}" }

      it 'does not delete the record from the database' do
        expect(User.count).to eq 1
      end

      it 'redirects to the sign in page' do
        expect(response).to redirect_to '/admin/sign_in'
      end

      it 'renders an unauthenticated message' do
        expect(flash[:alert]).to_not be_nil
      end
    end
  end
end
