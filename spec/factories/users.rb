FactoryBot.define do
  factory :user do
    email { FFaker::Internet.safe_email }
    password { FFaker::InternetSE.password }
    sign_in_count { ((1..1000).to_a).sample }
    add_attribute(:name) { FFaker::Name.name }
    role { ['admin', 'member'].sample }
  end
end
