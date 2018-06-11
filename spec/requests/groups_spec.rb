require 'rails_helper'

RSpec.describe 'Group Create', type: :request do
  describe 'GET #index' do
    context 'when signed in as an admin' do
      let(:admin) { FactoryBot.create(:admin) }
      before { sign_in admin }

      it 'returns a 200 OK status code' do
        get '/manage'
        expect(response.code).to eq '200'
      end
    end

    context 'when not signed in' do
      before { get '/manage' }

      it 'redirects to the home page' do
        expect(response).to redirect_to root_path
      end

      it 'displays an unauthorized message' do
        expect(flash[:alert]).to_not be_nil
      end
    end
  end

  describe 'POST #create' do
    context 'when signed in as an admin' do
      let(:admin) { FactoryBot.create(:admin) }

      context 'with valid params' do
        let(:group_params) { { groupme_id: 12345 } }

        before do
          allow(Faraday).to receive_message_chain('get.code').and_return(api_response_code)
          allow(Faraday).to receive_message_chain('get.body').and_return(api_response)
          sign_in admin
          post '/groups/create', params: group_params
        end

        context 'when group exists' do
          let(:api_response) do
            %Q({
              "response": {
                "name": "Some Group Name"
              }
            })
          end
          let(:api_response_code) { '200' }

          it 'creates a group in the database' do
            expect(Group.count).to eq 1
          end

          it 'redirects to the manage page' do
            expect(response).to redirect_to('/manage')
          end
        end

        context 'when group does not exist' do
          let(:api_response) { nil }
          let(:api_response_code) { '404' }

          it 'does not create a group in the database' do
            expect(Group.count).to eq 0
          end

          it 'redirects to the manage page' do
            expect(response).to redirect_to '/manage'
          end

          it 'displays an error' do
            expect(flash[:alert]).to eq 'Group Not Found'
          end
        end
      end

      context 'with invalid params' do
        before do
          sign_in admin
          post '/groups/create', params: { groupme_id: '' }
        end

        it 'does not create a group in the database' do
          expect(Group.count).to eq 0
        end

        it 'redirects to the manage page' do
          expect(response).to redirect_to '/manage'
        end

        it 'displays an error' do
          expect(flash[:alert]).to eq 'You must pass an ID'
        end
      end
    end

    context 'when not signed in' do
      before { post '/groups/create' }

      it 'redirects to the home page' do
        expect(response).to redirect_to root_path
      end

      it 'displays an unauthorized message' do
        expect(flash[:alert]).to_not be_nil
      end
    end
  end
end
