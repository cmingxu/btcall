

Rails.application.routes.draw do

  namespace :dashboard do
  get 'makers/index'
  end

  ResqueWeb::Engine.eager_load!

  require 'resque_web'
  resque_web_constraint = lambda { |request| request.remote_ip == '127.0.0.1' }
  constraints resque_web_constraint do
    mount ResqueWeb::Engine => "/resque_web"
  end
  captcha_route
  get "login" => "session#login"
  post "login" => "session#login"
  delete "logout" => "session#logout"
  get "register" => "session#register"
  get "activation" => "session#activation"
  post "register" => "session#register"

  %w(about team company jobs).each do |page|
    get page => "welcome##{page}"
  end


  namespace :dashboard do
    get "/" => "base#index"

    resources :bids, :only => [:create, :index]
    resources :recharges, :only => [:index]
    resources :withdraws, :only => [:index, :create]
    resources :users do
      collection do
        put :update_withdraw_address
      end
    end

    resources :withdraw_addresses, :only => [:index, :create]
    resources :makers, :only => [:index, :create]

  end

  namespace :admin do
    get "/" => "base#index"
  end


  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  root 'welcome#index'

  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Example resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Example resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Example resource route with more complex sub-resources:
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', on: :collection
  #     end
  #   end

  # Example resource route with concerns:
  #   concern :toggleable do
  #     post 'toggle'
  #   end
  #   resources :posts, concerns: :toggleable
  #   resources :photos, concerns: :toggleable

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end
end
