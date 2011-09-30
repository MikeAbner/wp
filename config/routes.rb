Wp::Application.routes.draw do
  root :to => 'home#index'
  
  match 'login'   => 'sessions#create',   :as => :login
  match 'logout'  => 'sessions#destroy',  :as => :logout

  match '/auth/facebook/callback' => 'sessions#fb_create', :as => :fb_login
  match '/auth/failure' => 'sessions#fb_failure'
  
  resources :activities do
    get :more, :on => :collection
  end
end
