Rails.application.routes.draw do
  root 'users#index'
  get '/users/:id', to: 'users#show'
  delete '/users/delete/:id', to: 'users#destroy'

  post '/messages', to: 'messages#incoming'

  devise_for :admin

  get '/manage', to: 'groups#index'
  post '/groups/create', to: 'groups#create'
  delete '/groups/delete/:id', to: 'groups#destroy'

  post '/group_check', to: 'group_checks#create'

  get '/upload', to: 'message_uploads#new'
  post '/upload', to: 'message_uploads#create'
end
