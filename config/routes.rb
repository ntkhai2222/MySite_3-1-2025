Rails.application.routes.draw do
  resource :session
  resources :passwords, param: :token
  resources :menus, only: [:index, :create, :new, :edit, :update]
  resources :pages, only: [:index, :create, :new, :edit, :update]
  resources :users, only: [:index, :create, :new, :edit, :update]
  resources :banners, only: [:index, :create, :new, :edit, :update]
  resources :orders, only: [:index, :show ]

  get 'product/:id/delete', to: 'products#delete', as: 'product_delete'
  get 'menu/:id/delete', to: 'menus#delete', as: 'menu_delete'
  get 'page/:id/delete', to: 'pages#delete', as: 'page_delete'
  get 'user/:id/delete', to: 'users#delete', as: 'user_delete'
  get 'banner/:id/delete', to: 'banners#delete', as: 'banner_delete'
  get 'order/:id/delete', to: 'orders#delete', as: 'order_delete'
  get 'order/:id/:status/update_status', to: 'orders#update_status', as: 'order_update_status'

  get "up" => "rails/health#show", as: :rails_health_check

  resources :products do
    resources :subscribers, only: [ :create ]
  end

  resource :unsubscribe, only: [ :show ]

  get 'admin', to: 'dashboard#index', as: 'dashboard'
  get 'session/logout', to: 'sessions#logout', as: 'session_logout'
  
  get '/', to: 'home#index', as: 'home_index'
  get '/product/:id/:slug', to: 'home#detail', as: 'product_detail'
  get '/products/:id/:slug', to: 'home#menu_products', as: 'product_menu'
  get '/page/:slug', to: 'home#page_detail', as: 'page_detail'
  get '/search', to: 'home#search', as: 'home_search'

  get 'login', to: 'home#login', as: 'home_login'
  post 'login', to: 'home#customer_login', as: 'home_customer_login'
  get 'register', to: 'home#register', as: 'home_register'
  post 'register', to: 'home#customer_register', as: 'home_customer_register'
  get 'logout', to: 'home#logout', as: 'home_logout'

  get 'account', to: 'account#index', as: 'account_index'
  get 'account/edit', to: 'account#edit', as: 'account_edit'
  post 'account/update', to: 'account#update', as: 'account_update'
  get 'account/password', to: 'account#password', as: 'account_password'
  post 'account/password_update', to: 'account#password_update', as: 'account_password_update'
  get 'account/logout', to: 'account#logout', as: 'account_logout'

  get 'cart', to: 'cart#index', as: 'cart_index'
  post 'add_to_cart', to: 'cart#add', as: 'cart_add'
  post 'update_cart', to: 'cart#update', as: 'cart_update'
  post 'remove_from_cart', to: 'cart#remove', as: 'cart_remove'
  get 'checkout', to: 'cart#checkout', as: 'cart_checkout'
  post 'checkout', to: 'cart#pay', as: 'cart_pay'
  get 'thank_you', to: 'cart#thank_you', as: 'cart_thank_you'
end
