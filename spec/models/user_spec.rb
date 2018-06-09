require 'rails_helper'

RSpec.describe User, type: :model do
  it { is_expected.to validate_presence_of :name }
  it { is_expected.to validate_presence_of :groupme_id }
  it { is_expected.to have_many(:liked_messages).dependent(:destroy) }
end
