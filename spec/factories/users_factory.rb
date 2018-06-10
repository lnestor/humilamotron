FactoryBot.define do
  factory :user do
    name 'First Last'
    sequence(:groupme_id) { |n| n }
  end
end
