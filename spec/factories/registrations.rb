FactoryBot.define do
  factory :registration do
    name { Faker::Name.name }
    email { Faker::Internet.email }
    password{Faker::Internet.password(min_length: 8) }
    trait :with_confirmation do
      password_confirmation { password }
    end
  end
end
