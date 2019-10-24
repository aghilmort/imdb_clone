require 'rails_helper'

RSpec.describe SessionsController, type: :controller do

	subject { described_class }

	before do
		@request.env["devise.mapping"] = Devise.mappings[:user]
	end

	describe '#create' do
		it 'returns returns 401 Unauthorized if user is not logged in' do
			post :create, format: :json

			expect(parse(response)).to eq({
         'error' => 'You need to sign in or sign up before continuing.'
       })
		end

		it 'returns auth token and user data when user is loggeed in' do
			user = create :user, role: :admin
			sign_in user

			post :create, format: :json

			expect(response).to match_json_schema("sessions/auth")
		end
	end

	describe '#destroy' do
		it 'destroys the session and returns HTTP status OK' do
			user = create :user, role: :admin
			sign_in user
			headers = { 'Authorization' => user.authentication_token }
			request.headers.merge! headers

			delete :destroy, format: :json

			expect(response).to have_http_status(200)
			expect(user.reload.authentication_token).to be_nil
		end
	end

	private

	def parse(response)
		JSON.parse(response.body).to_h.with_indifferent_access
	end

  def auth_header_for(user)
  	{ 'Authorization' => "Token #{user.authentication_token}" }
  end

end
