Rails.application.routes.draw do
  apipie
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  resources :tasks
  # post '/tasks', to: 'tasks#create'
  # get '/tasks', to: 'tasks#index'
  # get '/tasks/:id', to: 'tasks#show'
  # put '/tasks/:id', to: 'tasks#update'
  # delete '/tasks/:id', to: 'tasks#destroy'
end
