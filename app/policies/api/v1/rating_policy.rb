module Api
	module V1
		class RatingPolicy < ::ApplicationPolicy

		  class Scope < Scope
		    def resolve
		      scope.all
		    end
		  end

			def create?
				user.admin? || user.member?
			end

			def update?
				user.admin? || user.member?
			end

		end
	end
end
