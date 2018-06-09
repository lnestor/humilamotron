Rails.application.routes.draw do
  root 'users#index'
  post '/messages', to: 'messages#incoming'
end
