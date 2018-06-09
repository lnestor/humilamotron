require 'rails_helper'

RSpec.describe 'receiving messages from GroupMe', type: :request do
  let(:message_body) do
    {
      'attachments': [],
      'avatar_url': 'https://i.groupme.com/123456789',
      'created_at': 1302623328,
      'group_id': '1234567890',
      'id': '1234567890',
      'name': 'John',
      'sender_id': '12345',
      'sender_type': 'user',
      'source_guid': 'GUID',
      'system': false,
      'text': 'Hello world',
      'user_id': '1234567890'
    }
  end
  let(:message_response) { nil }

  before do
    allow(Faraday).to receive_message_chain('get.body').and_return(message_response)
  end

  context 'when a user likes their own message' do
    context 'when the message has not been logged' do
      context 'when the user is in the database' do
        let(:user) { FactoryBot.create(:user) }
        let(:message_response) do
          %Q({
            "response": {
              "messages": [{
                "id": "12345",
                "user_id": "#{user.groupme_id}",
                "group_id": "12345",
                "name": "#{user.name}",
                "text": "message content",
                "favorited_by": ["#{user.groupme_id}"]
              }]
            }
          })
        end

        before { post '/messages', params: { group_id: user.groupme_id } }

        it 'creates a liked message record' do
          expect(LikedMessage.count).to eq 1
        end

        it 'associates the liked message with the user' do
          expect(LikedMessage.first.user).to eq user
        end
      end

      context 'when the user is not in the database' do
        let(:message_response) do
          %Q({
            "response": {
              "messages": [{
                "id": "12345",
                "user_id": "12345",
                "group_id": "12345",
                "name": "First Last",
                "text": "message content",
                "favorited_by": ["12345"]
              }]
            }
          }).gsub(/\s+/, "")
        end

        before { post '/messages', params: { group_id: 1234 } }

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
    end
    
    context 'when the message has already been logged' do
      let(:liked_message) { FactoryBot.create(:liked_message) }
      let(:message_response) do
        %Q({
          "response": {
            "messages": [{
              "id": "#{liked_message.groupme_id}",
              "user_id": "12345",
              "group_id": "12345",
              "name": "First Last",
              "text": "message content",
              "favorited_by": ["12345"]
            }]
          }
        }).gsub(/\s+/, "")
      end

      before { post '/messages', params: { group_id: 1234 } }

      it 'does not create a liked message record' do
        expect(LikedMessage.count).to eq 1
      end
    end
  end

  context 'when the user did not like their own message' do
    let(:message_response) do
      %Q({
        "response": {
          "messages": [{
            "id": "12345",
            "user_id": "12345",
            "group_id": "12345",
            "name": "First Last",
            "text": "message content",
            "favorited_by": ["92374"]
          }]
        }
      }).gsub(/\s+/, "")
    end

    before { post '/messages', params: { group_id: 1234 } }

    it 'does not create a liked message record' do
      expect(LikedMessage.count).to eq 0
    end
  end
end
