HateaosBrowser::Application.routes.draw do
  get '/projects' => 'projects#index'
  get '/projects/:project_id' => 'projects#show'
  get '/projects/:project_id/resource/get' => 'resources#get', as: 'get_project_resource'

  get '/auth/:project_id' => 'sessions#new', as: 'login'
  get '/auth/:project_id/callback' => 'sessions#create', as: 'auth_callback'
  get '/logout' => 'sessions#destroy', as: 'logout'
  
  root "application#home"
end
