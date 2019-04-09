Rails.application.routes.draw do
  namespace :api do
    namespace :v1, defaults: { format: :json } do
      scope 'user/:user_id' do
        resource :balance, only: :show
        resource :feed, only: :show
        resources :payments, only: :create
      end
    end
  end
end
