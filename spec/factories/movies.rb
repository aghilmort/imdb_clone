FactoryBot.define do
  factory :movie do

  	transient do
  		with_ratings { false }
  	end

		title { FFaker::Movie.title }
		description { FFaker::Lorem.paragraph }
    image_url { "https://picsum.photos/1920/300?random=#{((1..10).to_a).sample}" }

    category

    after(:create) do |movie, evaluator|
    	create(:rating, movie: movie) if evaluator.with_ratings
  	end

  end
end