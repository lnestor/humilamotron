require 'rails_helper'

RSpec.describe 'checking if a group exists', type: :feature, js: true do
  context 'when logged in as an admin' do
    let(:admin) { FactoryBot.create(:admin) }

    context 'with valid params' do
      context 'when the group exists' do
        let(:api_response) do
          %Q({
            "response": {
              "id": "123",
              "name": "some name"
            },
            "meta": {
              "code": "200"
            }
          })
        end

        before do
          allow(Faraday).to receive_message_chain('get.body').and_return(api_response)

          sign_in admin
        end

        it 'displays the confirmation modal' do
          visit '/manage'
          within('#confirmation-form') { fill_in 'groupme_id', with: '123' }
          click_button 'Check Group'
          expect(page).to have_content 'some name'
        end
      end

      context 'when the group does not exist' do
        it 'displays the group not found modal'
      end
    end

    context 'with invalid params' do
      it 'displays the error modal'
      it 'displays an invalid parameters message'
    end
  end

  context 'when not logged in' do
    it 'redirects to the root page'
    it 'displays an unauthenticated message'
  end
end
