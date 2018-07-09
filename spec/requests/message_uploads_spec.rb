require 'rails_helper'

RSpec.describe 'uploading a messages JSON file', type: :request do
  describe 'GET #new' do
    context 'when signed in as an admin' do
      let(:admin) { FactoryBot.create(:admin) }
      before { sign_in admin }

      it 'returns a 200 OK status code' do
        get '/upload'
        expect(response.code).to eq '200'
      end
    end

    context 'when not signed in as an admin' do
      it 'redirects to the home page' do
        get '/manage'
        expect(response).to redirect_to '/admin/sign_in'
      end
    end
  end

  describe 'POST #create' do
    context 'when signed in as an admin' do
      let(:admin) { FactoryBot.create(:admin) }

      before { sign_in admin }

      context 'when the file is valid JSON' do
        context 'when the file is valid GroupMe JSON' do
          context 'when the group already exists' do
            let(:file) { fixture_file_upload('valid_messages_json.json') }
            let(:group_id) { '12345' }

            before do
              Group.create!(name: 'some group', groupme_id: group_id)
              post '/upload', params: { file: file }
            end

            it 'creates records in the database for liked messages' do
              expect(LikedMessage.count).to eq 1
            end

            it 'does not create a group in the database' do
              expect(Group.count).to eq 1
            end
          end

          context 'when the group does not exist' do
            context 'when GroupMe recognizes the group' do
              let(:file) { fixture_file_upload('valid_messages_json.json') }
              let(:group_info) do
                {
                  meta: {
                    code: 200
                  },
                  response: {
                    id: '12345',
                    name: 'some name'
                  }
                }
              end

              before do
                allow(Group).to receive(:get_info_from_groupme).and_return(group_info)
                post '/upload', params: { file: file }
              end

              it 'creates records in the database for liked messages' do
                expect(LikedMessage.count).to eq 1
              end

              it 'creates a group in the database' do
                expect(Group.count).to eq 1
              end
            end

            context 'when GroupMe does not recognize the group' do
              let(:file) { fixture_file_upload('valid_messages_json.json') }
              let(:group_info) do
                {
                  meta: {
                    code: 404
                  }
                }
              end

              before do
                allow(Group).to receive(:get_info_from_groupme).and_return(group_info)
                post '/upload', params: { file: file }
              end

              it 'does not create a liked message in the database' do
                expect(LikedMessage.count).to eq 0
              end

              it 'does not create a group in the database' do
                expect(Group.count).to eq 0
              end
            end
          end
        end

        context 'when the file is not valid GroupMe JSON' do
          let(:file) { fixture_file_upload('invalid_groupme_messages_json.json') }

          it 'fails gracefully and allows the user to upload a new file' do
            expect { post '/upload', xhr: true, params: { file: file } }.to_not raise_exception
            expect(LikedMessage.count).to eq 0
          end
        end
      end

      context 'when the file is not valid JSON' do
        let(:file) { fixture_file_upload('invalid_json.json') }

        it 'fails gracefully and allows the user to upload a new file' do
          expect { post '/upload', xhr: true, params: { file: file } }.to_not raise_exception
          expect(LikedMessage.count).to eq 0
        end
      end
    end

    context 'when not signed in as an admin' do
      it 'redirects to the home page' do
        post '/upload'
        expect(response).to redirect_to '/admin/sign_in'
      end
    end
  end
end
