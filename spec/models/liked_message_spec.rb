require 'rails_helper'

RSpec.describe LikedMessage, type: :model do
  it { is_expected.to validate_presence_of :content }
  it { is_expected.to validate_presence_of :groupme_id }
  it { is_expected.to belong_to(:group) }
  it { is_expected.to belong_to(:user) }
end
