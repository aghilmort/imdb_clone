module Api
	module V1
		class CategoryPolicy < ::ApplicationPolicy

		  class Scope < Scope
		    def resolve
		      scope.all
		    end
		  end

			def index?
				true
			end

			def create?
				user.admin?
			end

			def show?
				true
			end

		end
	end
end
