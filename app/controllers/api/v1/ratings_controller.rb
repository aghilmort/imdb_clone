module Api
	module V1
		class RatingsController < ApplicationController
			before_action :require_login

			def create
				authorize [:api, :v1, Rating], :create?

				params = rating_params.merge({user_id: current_user.id})
				rating = Rating.new(params)

				errors = capture_validation_errors do
					rating.save!
				end

				if errors
					return render_bad_request_with(errors)
				end

				render json: RatingSerializer.new(rating).serialized_json
			end

			def update
				rating = Rating.find(params[:id])

				authorize([:api, :v1, rating])

				errors = capture_validation_errors do
					rating.update!(rating_params)
				end

				if errors
					return render_bad_request_with(errors)
				end

				render json: RatingSerializer.new(rating).serialized_json
			end

			private

			def rating_params
				params.require(:rating)
					.permit(:movie_id, :score, :description)
			end

			def render_bad_request_with(errors)
				render json: { errors: [ { detail: errors } ] }, status: :bad_request
			end

			def capture_validation_errors
				begin
					yield
				rescue ActiveRecord::RecordInvalid => invalid
					return invalid.record.errors.messages
				end
				false
			end

		end
	end
end