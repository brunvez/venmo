Rails.application.routes.draw do
  namespace :api do
    namespace :v1, defaults: { format: :json } do
      scope 'user/:user_id' do
        resource :feed, only: :show
        resources :payments, only: :create
      end
    end
  end
end
