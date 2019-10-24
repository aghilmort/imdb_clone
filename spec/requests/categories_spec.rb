require 'rails_helper'

RSpec.describe "Categories", type: :request do
  
  describe "GET /api/v1/categories" do

    it "returns all records in the categories table" do
    	create_list :category, 3

      get api_v1_categories_path format: :json

      expect(response).to have_http_status(200)
      expect(response).to match_json_schema("api/v1/categories/index")
      expect(parse(response).count).to eq 3
    end

    context 'when a subcategory slug is provided' do
    	it 'returns the record having that sub category' do
    		create_category_with :sample_slug, :sample_sub_slug
    		create_category_with :sample_slug, :sample_sub_slug_2
    		create_category_with :sample_slug_2, :sample_sub_slug
    		
    		params = { filter: { slug: :sample_slug, sub_category_slug: :sample_sub_slug } }
    		get api_v1_categories_path format: :json, params: params

    		expect(response).to have_http_status(200)
	      expect(response).to match_json_schema("api/v1/categories/index")
	      expect(parse(response).count).to eq 1
    	end
    end

    context 'when a category slug is provided' do
    	it 'returns all records having this category' do
				create_category_with :sample_slug, :sample_sub_slug
    		create_category_with :sample_slug, :sample_sub_slug_2
    		create_category_with :sample_slug_2, :sample_sub_slug
    		
    		params = { filter: { slug: :sample_slug } }
    		get api_v1_categories_path format: :json, params: params

    		expect(response).to have_http_status(200)
	      expect(response).to match_json_schema("api/v1/categories/index")
	      expect(parse(response).count).to eq 2
    	end
    end
    
  end

  describe 'POST api/v1/categories' do

  	context 'when user is unauthenticated' do
	  	it 'returns HTTP status 401 Unauthorized' do
	  		post api_v1_categories_path format: :json, params: {}

	  		expect(response).to have_http_status(401)
	  		expect(response.body).to include('Access denied')
	  		expect(response).to match_json_schema("api/v1/401")
	  	end
	  end

	  context 'when user is authenticated' do

	  	context 'admin user' do
		  	context 'with valid params' do
			  	it 'creates a new category' do
			  		user = create :user, role: :admin
			  		auth_header = auth_header_for(user)

			  		expect {
			  			post api_v1_categories_path, params: category_params, headers: auth_header
			  		}.to change { Category.count }.by(1)

			  		expect(response).to have_http_status(200)
			  	end
			  end

				context 'with invalid params' do
			  	it 'returns HTTP status 400 Bad Request' do
			  		user = create :user, role: :admin
			  		auth_header = auth_header_for(user)
			  		params = category_params
			  		params[:data][:attributes][:title] = ''

						expect {
			  			post api_v1_categories_path, params: params, headers: auth_header
			  		}.not_to change { Category.count }

			  		expect(response).to have_http_status(400)
			  	end
			  end
		  end

		  context 'non-admin user' do
		  	it 'returns HTTP status 401 Unauthorized' do
		  		user = create :user, role: :member
		  		auth_header = auth_header_for(user)
		  		params = { valid: :params }

		  		post api_v1_categories_path, params: params, headers: auth_header

		  		expect(response).to have_http_status(401)
		  		expect(response.body).to include('Login Required')
		  	end
		  end

	  end

  end

 describe 'GET /api/v1/categories/:id' do

  	context 'when user is unauthenticated' do
	  	it 'returns HTTP status 200' do
	  		category = create(:category)

	  		get api_v1_category_path id: category.id, format: :json

	  		expect(response).to have_http_status(200)
	  		expect(parse(response)).to match_json_schema("api/v1/category")
	  	end
	  end

	  context 'when user is authenticated' do

	  	context 'admin user' do
		  	it 'returns HTTP status 200' do
		  		category = create(:category)
		  		user = create :user, role: :admin
		  		auth_header = auth_header_for(user)

		  		get api_v1_category_path(id: category.id, format: :json), headers: auth_header

		  		expect(response).to have_http_status(200)
		  		expect(parse(response)).to match_json_schema("api/v1/category")
		  	end
		  end

		  context 'non-admin user' do
		  	it 'returns HTTP status 200' do
		  		category = create(:category)
		  		user = create :user, role: :member
		  		auth_header = auth_header_for(user)

		  		get api_v1_category_path(id: category.id, format: :json), headers: auth_header

		  		expect(response).to have_http_status(200)
		  		expect(parse(response)).to match_json_schema("api/v1/category")
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

  def create_category_with(slug, sub_category_slug)
  	create :category, slug: slug, sub_category_slug: sub_category_slug
  end

  def category_params
  	{
			data: {
				attributes: {
					title: 'The Category',
					slug: 'the_category',
					sub_category_title: 'A Real Subcategory',
					sub_category_slug: 'a_real_subcategory',
					description: 'A real category',
					image_url: 'http://example.com',
				},
				relationships: {
					movies: {
						data: [
							{ id: 1, type: 'movie' },
							{ id: 2, type: 'movie' }
						]
					}
				},
				type: 'category'
			}
		}
  end

end
