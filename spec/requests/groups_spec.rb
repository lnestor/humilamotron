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
        expect(response).to redirect_to '/admin/sign_in'
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
        let(:groupme_id) { 12345 }
        let(:group_params) { { groupme_id: groupme_id } }

        before do
          allow(Faraday).to receive_message_chain('get.body').and_return(api_response)
          sign_in admin
        end

        context 'when groupme recognizes the group' do
          let(:api_response) do
            %Q({
              "response": {
                "name": "Some Group Name"
              },
              "meta": {
                "code": 200
              }
            })
          end

          context 'when the group is not already in the databse' do
            before { post '/groups/create', params: group_params }

            it 'creates a group in the database' do
              expect(Group.count).to eq 1
            end

            it 'redirects to the manage page' do
              expect(response).to redirect_to('/manage')
            end
          end

          context 'when the group already exists in the database' do
            before do
              FactoryBot.create(:group, groupme_id: groupme_id)
              post '/groups/create', params: group_params
            end

            it 'does not create a group in the database' do
              expect(Group.count).to eq 1
            end

            it 'displays an error message' do
              expect(flash[:alert]).to eq 'Group is already allowed.'
            end

            it 'redirects to the manage page' do
              expect(response).to redirect_to '/manage'
            end
          end
        end

        context 'when groupme does not recognize the group' do
          let(:api_response) { %Q({ "meta": { "code": 404 } }) }

          before { post '/groups/create', params: group_params }

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
        expect(response).to redirect_to '/admin/sign_in'
      end

      it 'displays an unauthorized message' do
        expect(flash[:alert]).to_not be_nil
      end
    end
  end

  describe '#destroy' do
    context 'when signed in as an admin' do
      let(:admin) { FactoryBot.create(:admin) }

      context 'when the group exists' do
        let(:group) { FactoryBot.create(:group) }

        before do
          sign_in admin
          delete "/groups/delete/#{group.id}"
        end

        it 'deletes the record from the database' do
          expect(Group.count).to eq 0
        end

        it 'displays a successful flash message' do
          expect(flash[:notice]).to eq 'Successfully deleted group.'
        end

        it 'redirects to the manage page' do
          expect(response).to redirect_to '/manage'
        end
      end

      context 'when the group does not exist' do
        before do
          sign_in admin
          delete '/groups/delete/1234123'
        end

        it 'displays an error flash message' do
          expect(flash[:alert]).to eq 'Group not found.'
        end

        it 'redirects to the manage page' do
          expect(response).to redirect_to '/manage'
        end

      end
    end

    context 'when not signed in' do
      before { delete '/groups/delete/123123' }

      it 'redirects to the home page' do
        expect(response).to redirect_to '/admin/sign_in'
      end

      it 'displays an unauthenticated message' do
        expect(flash[:alert]).to_not be_nil
      end
    end
  end
end
