require 'rails_helper'

RSpec.describe "Ratings", type: :request do

  describe 'POST api/v1/ratings' do

  	context 'when user is unauthenticated' do
	  	it 'returns HTTP status 401 Unauthorized' do
	  		post api_v1_ratings_path format: :json, params: {}

	  		expect(response).to have_http_status(401)
	  		expect(response.body).to include('Access denied')
	  		expect(response).to match_json_schema("api/v1/401")
	  	end
	  end

	  context 'when user is authenticated' do

	  	context 'admin user' do
		  	context 'with valid params' do
			  	it 'creates a new rating' do
			  		user = create :user, role: :admin
			  		movie = create(:movie)
			  		auth_header = auth_header_for(user)
			  		params = rating_params_for(movie)

			  		expect {
			  			post api_v1_ratings_path, params: params, headers: auth_header
			  		}.to change { Rating.count }.by(1)

			  		expect(response).to have_http_status(200)
			  	end
			  end

				context 'with invalid params' do
			  	it 'returns HTTP status 400 Bad Request' do
			  		user = create :user, role: :admin
			  		movie = create(:movie)
			  		auth_header = auth_header_for(user)
			  		params = rating_params_for(movie)
			  		params[:rating][:score] = ''

						expect {
			  			post api_v1_ratings_path, params: params, headers: auth_header
			  		}.not_to change { Rating.count }

			  		expect(response).to have_http_status(400)
			  	end
			  end
		  end

	  	context 'member user' do
		  	context 'with valid params' do
			  	it 'creates a new rating' do
			  		user = create :user, role: :member
			  		movie = create(:movie)
			  		auth_header = auth_header_for(user)
			  		params = rating_params_for(movie)

			  		expect {
			  			post api_v1_ratings_path, params: params, headers: auth_header
			  		}.to change { Rating.count }.by(1)

			  		expect(response).to have_http_status(200)
			  	end
			  end

				context 'with invalid params' do
			  	it 'returns HTTP status 400 Bad Request' do
			  		user = create :user, role: :member
			  		movie = create(:movie)
			  		auth_header = auth_header_for(user)
			  		params = rating_params_for(movie)
			  		params[:rating][:score] = ''

						expect {
			  			post api_v1_ratings_path, params: params, headers: auth_header
			  		}.not_to change { Rating.count }

			  		expect(response).to have_http_status(400)
			  	end
			  end
		  end

	  end

  end

  describe 'PATCH /api/v1/ratings/:id' do

  	context 'when user is unauthenticated' do
	  	it 'returns HTTP status 401 Unauthorized' do
	  		rating = create(:rating)

	  		patch api_v1_rating_path id: rating.id, params: {}

	  		expect(response).to have_http_status(401)
	  		expect(response.body).to include('Access denied')
	  		expect(response).to match_json_schema("api/v1/401")
	  	end
	  end

	  context 'when user is authenticated' do

	  	context 'admin user' do
		  	context 'with valid params' do
			  	it 'updates rating' do
			  		rating = create(:rating)
			  		user = create :user, role: :admin
			  		movie = create(:movie)
			  		auth_header = auth_header_for(user)
			  		params = rating_params_for(movie)

			  		expect {
			  			patch api_v1_rating_path(id: rating.id, params: params), headers: auth_header
			  		}.not_to change { Rating.count }

			  		expect(response).to have_http_status(200)
			  		parsed_response = parse(response)
			  		expect(parsed_response.dig(:rating, :movie_id)).to(
			  			eq params.dig(:data, :rating, :movie_id))

			  		expect(parsed_response.dig(:rating, :description)).to(
			  			eq params.dig(:data, :rating, :description))

						expect(parsed_response.dig(:rating, :score)).to(
							eq params.dig(:data, :rating, :score))
			  	end
			  end

				context 'with invalid params' do
			  	it 'returns HTTP status 400 Bad Request' do
			  		rating = create(:rating)
			  		movie = create(:movie)
			  		user = create :user, role: :admin
			  		auth_header = auth_header_for(user)
			  		params = rating_params_for(movie)

			  		params[:rating][:score] = ''

						expect {
			  			patch api_v1_rating_path(id: rating.id, params: params), headers: auth_header
			  		}.not_to change { Rating.count }

			  		expect(response).to have_http_status(400)
			  	end
			  end
		  end

			context 'member user' do
		  	context 'with valid params' do
			  	it 'updates rating' do
			  		rating = create(:rating)
			  		user = create :user, role: :member
			  		movie = create(:movie)
			  		auth_header = auth_header_for(user)
			  		params = rating_params_for(movie)

			  		expect {
			  			patch api_v1_rating_path(id: rating.id, params: params), headers: auth_header
			  		}.not_to change { Rating.count }

			  		expect(response).to have_http_status(200)
			  		parsed_response = parse(response)
			  		expect(parsed_response.dig(:rating, :movie_id)).to(
			  			eq params.dig(:data, :rating, :movie_id))

			  		expect(parsed_response.dig(:rating, :description)).to(
			  			eq params.dig(:data, :rating, :description))

						expect(parsed_response.dig(:rating, :score)).to(
							eq params.dig(:data, :rating, :score))
			  	end
			  end

				context 'with invalid params' do
			  	it 'returns HTTP status 400 Bad Request' do
			  		rating = create(:rating)
			  		movie = create(:movie)
			  		user = create :user, role: :member
			  		auth_header = auth_header_for(user)
			  		params = rating_params_for(movie)

			  		params[:rating][:score] = ''

						expect {
			  			patch api_v1_rating_path(id: rating.id, params: params), headers: auth_header
			  		}.not_to change { Rating.count }

			  		expect(response).to have_http_status(400)
			  	end
			  end
		  end

	  end

  end

  private

  def parse(response)
  	JSON.parse(response.body).to_h.with_indifferent_access[:data]
  end

  def auth_header_for(user)
  	{ 'Authorization' => "Token #{user.authentication_token}" }
  end

  def rating_params_for(movie)
  	{
			rating: {
				description: 'Rating comments',
				movie_id: movie.id,
				score: '5.3'
			},
			type: 'rating'
		}
  end

end
