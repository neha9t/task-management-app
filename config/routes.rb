Rails.application.routes.draw do
  apipie
  get '/', to: redirect('/apipie')

  scope 'api', as: 'api' do
    resources :tasks
    get '/autocomplete', to: 'tasks#autocomplete'
  end
end
