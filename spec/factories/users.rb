FactoryBot.define do
  factory :user do
    name { Faker::Name.first_name }
    email { Faker::Internet.unique.email }
    password { SecureRandom.uuid }
    jti { SecureRandom.uuid }
    role { "operator" }
    trait :owner do
      role { "owner" }
    end
    trait :postmaster do
      role { "postmaster" }
    end
  end
end
