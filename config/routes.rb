Rails.application.routes.draw do
  get '/.well-known/acme-challenge/:id' => 'pages#letsencrypt'

  # use a namespace to avoid resources colliding with usernames
  namespace :api do
    resources :devices, only: [] do
      post :trigger
    end
  end

  get 'what-is-red/:id(.:format)' => 'red#show'
  get 'what-is-red(.:format)' => 'red#index'

  get ':id(.:format)' => 'colors#show'
  get '/(.:format)' => 'colors#index'
  post '/' => 'webhooks#create'
end
