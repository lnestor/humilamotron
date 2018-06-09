FactoryBot.define do
  factory :liked_message do
    content 'some content'
    groupme_id 123
    group_groupme_id 123
    user
  end
end
