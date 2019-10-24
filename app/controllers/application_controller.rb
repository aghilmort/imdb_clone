class ApplicationController < ActionController::Base
  include Pundit

  protect_from_forgery

  before_action :require_login, except: [:index, :show]
  skip_before_action :verify_authenticity_token
  after_action :verify_authorized, except: [:index, :show]
  # after_action :verify_policy_scoped, only: :index

  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  def current_user
    @current_user ||= authenticate_token
  end

  def pagination_dict(object)
    {
      current_page: object.current_page,
      next_page: object.next_page,
      prev_page: object.prev_page,
      total_pages: object.total_pages,
      total_count: object.total_count,
    }
  end

  protected

  def render_unauthorized(message)
    errors = { errors: [ { detail: message } ] }
    render json: errors, status: :unauthorized
  end

  private

  def require_login
    authenticate_token || render_unauthorized('Access denied')
  end

  # def after_sign_out_path_for(resource_or_scope)
  #   login_path
  # end

  def authenticate_token
    authenticate_with_http_token do |token, options|
      User.find_by(authentication_token: token)
    end
  end

  def user_not_authorized
    render json: {
      "error": {
       "errors": [
        {
         "domain": "global",
         "reason": "required",
         "message": "Login Required",
         "locationType": "header",
         "location": "Authorization"
        }
       ],
       "code": 401,
       "message": "Login Required"
       }
      }.to_json, status: :unauthorized
  end

end
