Rails.application.routes.draw do
  apipie
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  resources :tasks
  get '/autocomplete', to: 'tasks#autocomplete'
end
