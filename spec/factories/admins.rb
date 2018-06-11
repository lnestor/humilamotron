FactoryBot.define do
  factory :admin do
    sequence(:email) { |n| "email#{n}@example.com" }
    password '123456'
  end
end
