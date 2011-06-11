Rails.application.routes.draw do
  namespace :manage do
    resources :orders, :only => [ :index, :show ]
  end
  
  scope :module => :manage do
    resources :orders do
      resources :fulfillments, :only => [ :new, :create ]
    end
  end

  resources :line_items, :only => [ :create, :update, :destroy ]
  
  get '/order'               => 'orders#new',    :as => :new_order
  get '/order/confirm'       => 'orders#confirm', :as => :confirm
  get '/checkout'            => 'orders#edit',   :as => :checkout
  put '/checkout'            => 'orders#update', :as => :checkout
  get '/update_state_select' => 'orders#update_state_select'
  
  post '/update_line_items' => 'line_items#update_all', :as => :update_line_items
  
  get  '/paypal'  => 'orders#paypal', :as => :paypal
  post '/ipns'    => 'order_transactions#ipns'
  
  post '/subscribe' => 'patrons#subscribe', :as => :subscribe
end