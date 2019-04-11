require 'sidekiq/web'

Rails.application.routes.draw do
  match "/graphql", to: "graphql#execute", via: [:get, :post, :options]

  get '/link/:id' => "shortened#show"

  devise_for :users,
             path: '',
             path_names: {
               sign_in: 'login',
               sign_out: 'logout',
               registration: 'signup'
             },
             controllers: {
               sessions: 'sessions',
               registrations: 'registrations'
             }
  
  mount Sidekiq::Web => '/sidekiq'
end
