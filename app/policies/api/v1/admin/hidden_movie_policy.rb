module Api
	module V1
		module Admin
			class HiddenMoviePolicy < ApplicationPolicy

			  class Scope < Scope
			    def resolve
			      scope.all
			    end
			  end

			  def index?
			  	user.admin?
			  end

			end
		end
	end
end
