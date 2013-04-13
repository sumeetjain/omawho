Omawho::Application.routes.draw do
  resources :events, :except => :show do
    post 'attend' => 'events#attend', :as => :attend
    put 'approve' => 'events#approve', :as => :approve
  end
  
  match 'why' => 'users#why', :as => :why
  match 'beta' => 'users#beta', :as => :beta
  
  match 'profile' => 'users#edit', :as => :profile
  
  resources :images, :except => :show

  resources :password_resets
  resources :user_sessions
  resources :users, :except => :show
  
  match 'add' => 'users#new', :as => :signup
  match 'login' => 'user_sessions#new', :as => :login
  match 'logout' => 'user_sessions#destroy', :as => :logout

  match 'event/:event' => 'users#index', :as => :event
  match 'category/:category' => 'users#index', :as => :category
  
  match '/feed' => 'users#feed', :as => :feed, :defaults => {:format => 'atom'}
  root :to => 'users#index'
  
  match ':username' => 'users#show', :as => :view_profile
end