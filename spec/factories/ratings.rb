FactoryBot.define do
  factory :rating do
    movie
    user
    score { ((1..10).to_a).sample }
    description { FFaker::Lorem.paragraph }
  end
end
