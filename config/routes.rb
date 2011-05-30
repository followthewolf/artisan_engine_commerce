Rails.application.routes.draw do
  namespace :manage do
    resources :orders, :only => [ :index, :show ]
  end
  
  scope :module => :manage do
    resources :orders do
      resources :fulfillments, :only => [ :new, :create ]
    end
  end

  resources :line_items, :only => [ :create ]
  
  get '/order'               => 'orders#new',    :as => :new_order
  get '/checkout'            => 'orders#edit',   :as => :checkout
  put '/checkout'            => 'orders#update', :as => :checkout
  get '/update_state_select' => 'orders#update_state_select'
  
  get  '/paypal'  => 'orders#paypal', :as => :paypal
  post '/ipns'    => 'order_transactions#ipns'
end