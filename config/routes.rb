Rails.application.routes.draw do
  
  root :to => 'guest/teachers#index'

  scope module: 'guest' do
    resources :teachers do
      post    'search'  , :on => :collection
    end
    resources :students
  end

  namespace :user do
    get       'login'             => 'login#login'
    get       'logout'            => 'login#logout'
    post      'authentication'    => 'login#auth', :as => 'auth'
    get       'forgot'            => 'login#forgot'
    post      'password'          => 'login#password'

    resources :years
    resources :students do
      post    'accept'    , :on => :member
    end
    resources :teachers
  end

  namespace :admin do
    get       'login'             => 'login#login'
    get       'logout'            => 'login#logout'
    post      'authentication'    => 'login#auth', :as => 'auth'
    
    resources :titles, :categories, :only => [:index, :create, :update, :destroy] do # :groups
      get     'edit'      , :on => :collection
    end
    
    resources :vacancies, :admins

    resources :teachers do
      get     'password'  , :on => :collection
      post    'sends'     , :on => :collection
    end

    resources :students do
      get     'teacher'   , :on => :member
      patch   'replace'   , :on => :member
    end
    resources :years do
      get     'ratio'     , :on => :member
      post    'archive'   , :on => :member
      get     'remain'    , :on => :member
    end
  end

  namespace :develop do
    resources :admins
  end

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
