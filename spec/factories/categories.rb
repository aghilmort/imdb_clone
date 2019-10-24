FactoryBot.define do
  factory :category do
    title { FFaker::Internet.domain_word }
    slug { title.parameterize }
    sub_category_title { FFaker::Internet.domain_word }
		sub_category_slug { sub_category_title.parameterize } 
    description { FFaker::Lorem.paragraph }
    image_url { "https://picsum.photos/300/300?random=#{((1..10).to_a).sample}" }
  end
end
