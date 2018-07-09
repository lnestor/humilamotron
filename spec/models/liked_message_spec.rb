require 'rails_helper'

RSpec.describe LikedMessage, type: :model do
  it { is_expected.to validate_presence_of :groupme_id }
  it { is_expected.to belong_to(:group) }
  it { is_expected.to belong_to(:user) }

  describe '.liked_own_message?' do
    context 'when the user liked their own message' do
      let(:msg) { { user_id: '1', favorited_by: [ '1' ] } }

      it 'returns true' do
        expect(LikedMessage.liked_own_message?(msg)).to be_truthy
      end
    end

    context 'when the user did not like their own message' do
      let(:msg) { { user_id: '1', favorited_by: [] } }

      it 'returns false' do
        expect(LikedMessage.liked_own_message?(msg)).to be_falsey
      end
    end
  end

  describe '.get_image' do
    context 'when the message has an image attachment' do
      let(:msg) { { attachments: [{ type: 'image', url: 'some url' }] } }

      it 'returns the image url' do
        expect(LikedMessage.get_image(msg)).to eq 'some url'
      end
    end

    context 'when the message has a non-image attachment' do
      let(:msg) { { attachments: [{ type: 'not an image' }] } }

      it 'returns nil' do
        expect(LikedMessage.get_image(msg)).to be_nil
      end
    end

    context 'when the message has no attachment' do
      let(:msg) { { attachments: [] } }

      it 'returns nil' do
        expect(LikedMessage.get_image(msg)).to be_nil
      end
    end
  end
end
