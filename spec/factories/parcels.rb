FactoryBot.define do
  factory :parcel do
    weight { rand(1..10) }
    volume { rand(1..10) / 1e3 }
    status { "pending" }
    trait :with_cost do
      cost { rand(1..15) }
    end
    trait :picked do
      status { "picked" }
    end
    trait :delivered do
      status { "delivered" }
    end
    trait :retrieved do
      status { "retrieved" }
    end
    train
    association :owner, factory: :user
  end
end
