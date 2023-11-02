FactoryBot.define do
  factory :train do
    name { Faker::Name.first_name }
    cost { rand(1..15) }
    weight { rand(100.0..500.0).round(2) }
    volume { rand(1.0..10.0).round(2) }
    lines { LINES.sample(2) }
    status { "waiting" }
    trait :booked do
      status { "booked" }
    end
    trait :random_lines do
      lines { [*("A".."Z")].sample(2) }
    end
    trait :reached do
      status { "reached" }
    end
    trait :withdrawn do
      status { "withdrawn" }
    end
    association :operator, factory: :user
  end
end
