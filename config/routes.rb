Releaseboard::Application.routes.draw do
  # The priority is based upon order of creation:
  # first created -> highest priority.
  root :to => 'projects#index'
  
#  match '/echo' => 'projects#echo', :as => :echo
  match '/projects/:id/releases' => 'projects#show'
  
  resources :projects do
    resources :releases, :except => [:index, :new, :edit]
    resources :notifications
  end
  
  resources :environments
  resources :releases
  resources :notifications
end
