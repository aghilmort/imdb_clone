module Api
	module V1
		class MoviePolicy < ::ApplicationPolicy

			class Scope < Scope
				def resolve
					scope.all
				end
			end

			def index?
				true
			end

			def update?
				user.admin?
			end

			def create?
				user.admin?
			end

			def show?
				true
			end

			def destroy?
				user.admin?
			end

			def hidden_index?
				user.admin?
			end

		end
	end
end
