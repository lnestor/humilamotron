Rails.application.routes.draw do
  root 'users#index'
  get '/users/:id', to: 'users#show'

  post '/messages', to: 'messages#incoming'

  devise_for :admin

  get '/manage', to: 'groups#index'
  post '/groups/create', to: 'groups#create'
  delete '/groups/delete/:id', to: 'groups#destroy'

  post '/group_check', to: 'group_checks#create'
end
