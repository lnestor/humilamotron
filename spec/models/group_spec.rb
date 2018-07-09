require 'rails_helper'

RSpec.describe Group, type: :model do
  it { is_expected.to validate_presence_of :name }
  it { is_expected.to validate_presence_of :groupme_id }
  it { is_expected.to have_many :liked_messages }

  describe '.get_info_from_groupme' do
    it 'submits a post request to the GroupMe API' do
      expect(Faraday).to receive(:get).with(anything).and_return double(body: '{ "some": "json" }')
      group_info = Group.get_info_from_groupme(1)
      expect(group_info[:some]).to eq 'json'
    end
  end
end
