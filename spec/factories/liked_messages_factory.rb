FactoryBot.define do
  factory :liked_message do
    content 'some content'
    sequence(:groupme_id) { |n| n }
    group
    user
  end
end
