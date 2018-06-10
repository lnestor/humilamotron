FactoryBot.define do
  factory :group do
    name "Group Name"
    sequence(:groupme_id) { |n| n }
  end
end
