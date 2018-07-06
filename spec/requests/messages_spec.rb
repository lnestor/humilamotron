require 'rails_helper'

RSpec.describe 'receiving messages from GroupMe', type: :request do
  let(:id) { '12345' }
  let(:user_id) { '12345' }
  let(:group_id) { '12345' }
  let(:name) { 'first last' }
  let(:favorited_by) { [] }
  let(:attachments) { [] }
  let(:message_hash) do
    {
      response: {
        messages: [{
          id: "#{id}",
          created_at: 1302623328,
          user_id: "#{user_id}",
          group_id: "#{group_id}",
          name: "#{name}",
          text: 'message content',
          favorited_by: favorited_by,
          attachments: attachments
        }]
      }
    }
  end

  before do
    allow(Faraday).to receive('get').and_return(double(body: message_hash.to_json))
  end

  context 'when the group is registered' do
    let(:group) { FactoryBot.create(:group) }
    let(:group_id) { group.groupme_id }
    let(:post_params) do
      {
        group_id: "#{group.groupme_id}"
      }
    end

    context 'when a user likes their own message' do
      context 'when the message has not been logged' do
        context 'when the user is in the database' do
          let(:user) { FactoryBot.create(:user) }
          let(:user_id) { user.groupme_id }
          let(:name) { user.name }
          let(:favorited_by) { ["#{user.groupme_id}"] }

          before { post '/messages', params: post_params }

          it 'creates a liked message record' do
            expect(LikedMessage.count).to eq 1
          end

          it 'associates the liked message with the user' do
            expect(LikedMessage.first.user).to eq user
          end
        end

        context 'when the user is not in the database' do
          let(:favorited_by) { ["#{user_id}"] }

          before { post '/messages', params: post_params }

          it 'creates a user record' do
            expect(User.count).to eq 1
          end

          it 'creates a liked message record' do
            expect(LikedMessage.count).to eq 1
          end

          it 'associates the liked message with the user' do
            expect(LikedMessage.first.user.groupme_id).to eq 12345
          end
        end

        context 'when the message has an image attachment' do
          let(:favorited_by) { ["#{user_id}"] }
          let(:attachments) { [{ type: "image", url: "some url" }] }

          before { post '/messages', params: post_params }

          it 'adds an image url to the record in the database' do
            expect(LikedMessage.first.image_url).to eq 'some url'
          end
        end

        context 'when the message has a non image attachment' do
          let(:favorited_by) { ["#{user_id}"] }
          let(:attachments) { [{ type: "some type" }] }

          before { post '/messages', params: post_params }

          it 'does not add an image url to the database' do
            expect(LikedMessage.first.image_url).to eq nil
          end
        end
      end

      context 'when the message has already been logged' do
        let(:liked_message) { FactoryBot.create(:liked_message) }
        let(:id) { liked_message.groupme_id }

        before { post '/messages', params: post_params }

        it 'does not create a liked message record' do
          expect(LikedMessage.count).to eq 1
        end
      end
    end

    context 'when the user did not like their own message' do
      let(:favorited_by) { ["4325"] }

      before { post '/messages', params: post_params }

      it 'does not create a liked message record' do
        expect(LikedMessage.count).to eq 0
      end
    end
  end

  context 'when the group is not registered' do
    let(:post_params) { { group_id: 123 } }

    before { post '/messages', params: post_params }

    it 'does not create a liked message' do
      expect(LikedMessage.count).to eq 0
    end
  end
end
