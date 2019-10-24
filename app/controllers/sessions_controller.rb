class SessionsController < Devise::SessionsController
  skip_before_action :require_login, raise: false
  skip_after_action :verify_authorized
  skip_before_action :verify_signed_out_user, only: :destroy

  respond_to :json, :html

  def new
    respond_to do |format|
      format.html { render plain: '' }
      format.json { render json: {}, status: 200 }
    end
  end

	def create
    super do |user|
      if request.format.json?
        data = {
          token: user.authentication_token,
          email: user.email,
          role: user.role,
        }
        render json: data, status: 201 and return
      end
    end
  end

  def destroy
    token = request.headers["Authorization"]
    token.slice! 'Token '

    if request.format.json?
      user = User.find_by(authentication_token: token)
      logout user
      render json: {}, status: 200
    end
  end

  private

  def logout(user)
    user.invalidate_token
  end

end
