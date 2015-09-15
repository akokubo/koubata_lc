Rails.application.routes.draw do
  resources :notifications
  mount RailsAdmin::Engine => '/admin', as: 'rails_admin'
  root to: 'home#index'

  match '/need_help',   to: 'home#need_help',   via: 'get'
  match '/about',       to: 'home#about',       via: 'get'
  match '/contact',     to: 'home#contact',     via: 'get'
  match '/status',      to: 'home#status',      via: 'get'
  match '/watch_list',  to: 'home#watch_list',  via: 'get'
  match '/new_display', to: 'home#new_display', via: 'get'
  match '/detailed',    to: 'home#detailed',    via: 'get'
  match '/search',      to: 'home#search',      via: 'get'

  devise_for :users, controllers: { registrations: 'user/registrations' }

  resources :users do
    member do
      get 'talks'
      get 'negotiations'
      get 'offerings'
      get 'wants'
      get 'payments'
      get 'entries'
      get 'contracts'
      get 'entrusts'
      get :following, :followers
    end
  end
  match '/users/profile/edit', to: 'users#edit', via: 'get'

  resources :offerings
  resources :wants
  resources :entries
  resources :contracts
  resources :entrusts
  resources :messages
  resources :talks
  resources :negotiations
  resource :account
  resources :payments
  resources :entries, only: [:create, :destroy]
  resources :relationships, only: [:create, :destroy]

  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  # root 'welcome#index'

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
