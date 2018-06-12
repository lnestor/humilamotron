Rails.application.routes.draw do
  devise_for :admins, only: []
  root 'users#index'
  get '/users/:id', to: 'users#show'
  post '/messages', to: 'messages#incoming'
  devise_for :admin
  get '/manage', to: 'groups#index'
  post '/groups/create', to: 'groups#create'
  post '/group_check', to: 'group_checks#create'
  delete '/groups/delete/:id', to: 'groups#destroy'
end
