Releaseboard::Application.routes.draw do
  # The priority is based upon order of creation:
  # first created -> highest priority.
  root :to => 'projects#index'

  get '/login' => 'application#login'

  resources :projects do
    resources :releases, :constraints => {:id => /[\w\-.]+?/, :format => /html|csv/}
  end
end
