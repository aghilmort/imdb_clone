Rails.application.routes.draw do
	devise_for :users, controllers: { sessions: 'sessions' }

	mount_ember_app :frontend, to: "/"

  namespace :api, constraints: { format: :json } do
  	namespace :v1 do
  		resources :movies
  		resources :ratings
  		resources :categories, only: [:index, :show, :create]

      get '/categories/:slug', to: 'categories#index'
      get '/categories/:slug/:sub_category_slug', to: 'categories#index'
  	end
  end

end
