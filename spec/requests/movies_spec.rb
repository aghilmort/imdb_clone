require 'rails_helper'

RSpec.describe 'Movies', type: :request do

  describe 'GET api/v1/movies' do

    it 'returns a paginated list of movies' do
    	create_list :movie, 3, with_ratings: true

     	get api_v1_movies_path format: :json, params: { page: 1, per_page: 2 }

      expect(response).to have_http_status(200)
      expect(response).to match_json_schema("api/v1/movies/index")
      expect(parse(response).count).to eq 2
    end

  end

  describe 'POST api/v1/movies' do

  	context 'when user is unauthenticated' do
	  	it 'returns HTTP status 401 Unauthorized' do
	  		post api_v1_movies_path format: :json, params: {}

	  		expect(response).to have_http_status(401)
	  		expect(response.body).to include('Access denied')
	  		expect(response).to match_json_schema("api/v1/401")
	  	end
	  end

	  context 'when user is authenticated' do

	  	context 'admin user' do
		  	context 'with valid params' do
			  	it 'creates a new movie' do
			  		user = create :user, role: :admin
			  		category = create(:category)
			  		auth_header = auth_header_for(user)
			  		params = movie_post_params_with(category)

			  		expect {
			  			post api_v1_movies_path, params: params, headers: auth_header
			  		}.to change { Movie.count }.by(1)

			  		expect(response).to have_http_status(200)
			  	end
			  end

				context 'with invalid params' do
			  	it 'returns HTTP status 400 Bad Request' do
			  		user = create :user, role: :admin
			  		auth_header = auth_header_for(user)
			  		params = { invalid: :params }

						expect {
			  			post api_v1_movies_path, params: params, headers: auth_header
			  		}.not_to change { Movie.count }

			  		expect(response).to have_http_status(400)
			  	end
			  end
		  end

		  context 'non-admin user' do
		  	it 'returns HTTP status 401 Unauthorized' do
		  		user = create :user, role: :member
		  		auth_header = auth_header_for(user)
		  		params = { valid: :params }

		  		post api_v1_movies_path, params: params, headers: auth_header

		  		expect(response).to have_http_status(401)
		  		expect(response.body).to include('Login Required')
		  	end
		  end

	  end

  end

  describe 'PATCH /api/v1/movies/:id' do

  	context 'when user is unauthenticated' do
	  	it 'returns HTTP status 401 Unauthorized' do
	  		movie = create(:movie)

	  		patch api_v1_movie_path id: movie.id, params: {}

	  		expect(response).to have_http_status(401)
	  		expect(response.body).to include('Access denied')
	  		expect(response).to match_json_schema("api/v1/401")
	  	end
	  end

	  context 'when user is authenticated' do

	  	context 'admin user' do
		  	context 'with valid params' do
			  	it 'updates movie' do
			  		movie = create(:movie)
			  		user = create :user, role: :admin
			  		category = create(:category)
			  		auth_header = auth_header_for(user)
			  		params = movie_post_params_with(category)
			  		params[:data].merge!({ id: movie.id })

			  		expect {
			  			patch api_v1_movie_path(id: movie.id, params: params), headers: auth_header
			  		}.not_to change { Movie.count }

			  		expect(response).to have_http_status(200)
			  		parsed_response = parse(response)
			  		expect(parsed_response.dig(:attributes, :title)).to(
			  			eq params.dig(:data, :attributes, :title))

			  		expect(parsed_response.dig(:attributes, :description)).to(
			  			eq params.dig(:data, :attributes, :description))

						expect(parsed_response.dig(:attributes, :image_url)).to(
							eq params.dig(:data, :attributes, :image_url))
			  	end
			  end

				context 'with invalid params' do
			  	it 'returns HTTP status 400 Bad Request' do
			  		movie = create(:movie)
			  		category = create(:category)
			  		user = create :user, role: :admin
			  		auth_header = auth_header_for(user)
			  		params = movie_post_params_with(category)

			  		params[:data][:attributes][:title] = ''

						expect {
			  			patch api_v1_movie_path(id: movie.id, params: params), headers: auth_header
			  		}.not_to change { Movie.count }

			  		expect(response).to have_http_status(400)
			  	end
			  end
		  end

		  context 'non-admin user' do
		  	it 'returns HTTP status 401 Unauthorized' do
		  		movie = create(:movie)
		  		user = create :user, role: :member
		  		auth_header = auth_header_for(user)
		  		params = { valid: :params }

		  		patch api_v1_movie_path(id: movie.id, params: params), headers: auth_header

		  		expect(response).to have_http_status(401)
		  		expect(response.body).to include('Login Required')
		  	end
		  end

	  end

  end

  describe 'GET /api/v1/movies/:id' do

  	context 'when user is unauthenticated' do
	  	it 'returns HTTP status 200' do
	  		movie = create(:movie)

	  		get api_v1_movie_path id: movie.id, format: :json

	  		expect(response).to have_http_status(200)
	  		expect(parse(response)).to match_json_schema("api/v1/movie")
	  	end
	  end

	  context 'when user is authenticated' do

	  	context 'admin user' do
		  	it 'returns HTTP status 200' do
		  		movie = create(:movie)
		  		user = create :user, role: :admin
		  		auth_header = auth_header_for(user)

		  		get api_v1_movie_path(id: movie.id, format: :json), headers: auth_header

		  		expect(response).to have_http_status(200)
		  		expect(parse(response)).to match_json_schema("api/v1/movie")
		  	end
		  end

		  context 'non-admin user' do
		  	it 'returns HTTP status 200' do
		  		movie = create(:movie)
		  		user = create :user, role: :member
		  		auth_header = auth_header_for(user)

		  		get api_v1_movie_path(id: movie.id, format: :json), headers: auth_header

		  		expect(response).to have_http_status(200)
		  		expect(parse(response)).to match_json_schema("api/v1/movie")
		  	end
		  end

	  end

  end

  describe 'DELETE /api/v1/movies/:id' do

  	context 'when user is unauthenticated' do
	  	it 'returns HTTP status 401 Unauthorized' do
	  		movie = create(:movie)

	  		delete api_v1_movie_path id: movie.id

	  		expect(response).to have_http_status(401)
	  		expect(response.body).to include('Access denied')
	  		expect(response).to match_json_schema("api/v1/401")
	  	end
	  end

	  context 'when user is authenticated' do

	  	context 'admin user' do
		  	it 'deletes movie' do
		  		movie = create(:movie)
		  		user = create :user, role: :admin
		  		auth_header = auth_header_for(user)

		  		expect {
		  			delete api_v1_movie_path(id: movie.id), headers: auth_header
		  		}.to change { Movie.count }.by(-1)

		  		expect(response).to have_http_status(204)
		  		expect(response.body).to be_empty
		  	end
		  end

		  context 'non-admin user' do
		  	it 'returns HTTP status 401 Unauthorized' do
		  		movie = create(:movie)
		  		user = create :user, role: :member
		  		auth_header = auth_header_for(user)

		  		delete api_v1_movie_path(id: movie.id), headers: auth_header

		  		expect(response).to have_http_status(401)
		  		expect(response.body).to include('Login Required')
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

  def movie_post_params_with(category)
  	{
			data: {
				attributes: {
					title: 'The Action Movie',
					description: 'Where all action happens!',
					image_url: 'http://example.com',
					visible: true,
					average_rating: nil,
				},
				relationships: {
					category: {
						data: {
							id: category.id,
							type: 'categories' 
						}
					}
				},
				type: 'movies'
			}
		}
  end

end
