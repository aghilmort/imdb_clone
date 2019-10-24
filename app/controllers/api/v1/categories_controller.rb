module Api
	module V1
		class CategoriesController < ApplicationController

			def index
				query =
					if sub_category?
						sub_category_query
					elsif category?
						if category_id_detected?
							return redirect_to_category_show_action 
						end
						category_query
					else
						all_categories_query
					end

				render json: CategorySerializer.new(query.order(:slug)).serialized_json
			end

			def create
				authorize [:api, :v1, Category], :create?

				category = Category.new(category_params.to_h)

				errors = capture_validation_errors do
					category.save!
				end

				if errors
					return render_bad_request_with(errors)
				end

				category.id

				render json: CategorySerializer.new(category).serialized_json
			end

			def show
				render json: CategorySerializer.new(
					Category.find(params[:id])).serialized_json
			end

			private

			def slug
				@slug ||= params.dig(:filter, :slug)
			end

			def sub_category_slug
				@sub_category_slug ||= params.dig(:filter, :sub_category_slug)
			end

			def category?
				slug.present?
			end

			def sub_category?
				slug.present? && sub_category_slug.present?
			end

			def sub_category_query
				Category.sub_category(slug, sub_category_slug)
			end

			def redirect_to_category_show_action
				redirect_to controller: :categories, action: :show, id: slug
			end

			def category_id_detected?
				slug.is_a? Numeric
			end

			def category_query
				Category.where(slug: slug)
			end

			def all_categories_query
				Category.distinct(:slug)
			end

			def category_params
				params
					.require(:data)
					.require(:attributes)
					.permit(
						:title,
						:sub_category_title,
						:slug,
						:sub_category_slug,
						:image_url
					)
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
