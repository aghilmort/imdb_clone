module Api
	module V1
		class MoviesController < ::ApplicationController

			def index
				if show_hidden?
					authorize [:api, :v1, Movie], :hidden_index?
				end

				movies = paginated_sorted_movies_with_associations

				render json: serialized_movies(movies),
					params: pagination_info
			end

			def create
				authorize [:api, :v1, Movie], :create?

				movie = Movie.new(deserialized_params.except(:average_rating))

				errors = capture_validation_errors do
					movie.save!
				end

				if errors
					return render_bad_request_with(errors)
				end

				movie.id
				
				render json: MovieSerializer.new(movie).serialized_json
			end

			def update
				authorize [:api, :v1, movie], :update?
				
				errors = capture_validation_errors do
					movie.update!(deserialized_params.except(:average_rating))
				end

				if errors
					return render_bad_request_with(errors)
				end

				movie.id

				render json: MovieSerializer.new(movie).serialized_json
			end

			def show
				params = {
					params: {
						include: [:category, :ratings]
					}
				}

				serialized_movie = MovieSerializer.new(movie, params)
					.serialized_json

				render json: serialized_movie
			end

			def destroy
				authorize [:api, :v1, movie], :destroy?

				Movie.destroy(params[:id])
				head :no_content
			end

			private

			def slug
				@slug ||= params.dig(:filter, :slug)
			end

			def sub_category_slug
				@sub_category_slug ||= params.dig(:filter, :sub_category_slug)
			end

			def movie
				@movie ||= Movie.find(params[:id])
			end

			def serialized_movies(movies)
				MovieSerializer.new(movies, serialization_params(movies))
					.serialized_json
			end

			def render_bad_request_with(errors)
				render json: { errors: [ { detail: errors } ] }, status: :bad_request
			end

			def paginated_sorted_movies_with_associations
				info = pagination_info
				
				query = Movie.left_outer_joins(:category, :ratings).distinct
				query = query.where(visible: show_hidden? ? false : true).order(:title)
				query = query.with_sub_category(slug, sub_category_slug) if with_sub_category
				query = query.without_sub_category(slug) if without_sub_category
				query = query.page(info[:page]).per(info[:per_page])
			end

			def with_sub_category
				slug.present? && sub_category_slug.present?
			end

			def without_sub_category
				slug.present? && sub_category_slug.nil?
			end

			def deserialized_params
				::ActiveModelSerializers::Deserialization.jsonapi_parse(
						movie_params.to_h
					)
			end

			def movie_params
				params.permit(data: [
					{ attributes: [:title, :description, :image_url, :visible, :average_rating] },
					{ relationships: [category: [{ data: [:id, :type] }]] },
					:type
				])
			end

			def show_hidden?
				current_user.admin? && hidden_movies?
			end

			def hidden_movies?
				params.permit(:hidden).present?
			end

			def category_params
				params.permit(:slug, :sub_category_slug)
			end

			def serialization_params(movies)
				{
					params: {
						user: current_user,
						include: [:category, :ratings]
					},
					meta: pagination_dict(movies).merge(pagination_info)
				}
			end

			def pagination_info
				{
		      page: (params[:page] || 1).to_i,
		      per_page: (params[:per_page] || 9).to_i
		    }
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
