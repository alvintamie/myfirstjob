Myfirstjob::Application.routes.draw do

  resource :sessions, :only => [:new, :create, :destroy]

  get "signup", to: "users#new", as: "signup"
  get "login", to: "sessions#new", as: "login"
  match 'logout', to: 'sessions#destroy', as: 'logout'

  match "profile", to: "users#profile", via: [:get]
  resource :profile, :controller => :users do
    get :following, :followers, :change_password, :forget_password, :activities, :recommends, :wants, :photos, :reviews
    post :post_forget_password
    match "retrieve_password/:id/:expired/:digest", :to => "users#retrieve_password", :as => :retrieve_password, :via => :get
    match "activate/:id/:key/:digest", :to => "users#activate", :as => :activate, :via => :get
  end

  resources :users do
    collection do
      get :confirmation_page
    end
  end

  resources :employers
  resources :company_details
  resources :events
  namespace :employer do
    root to: "homes#index"
    get "homes" => "homes#index"
    resources :company_details
    resources :users
    resources :jobs
  end

  namespace :student do
    root to: "homes#index"
    get "homes" => "homes#index"
    resources :company_details
    resources :users
    resources :testimonials do
      collection do
        post :comment
      end
      member do        
        get :upvote
        get :downvote
      end
    end
    resources :interviews do
      collection do
        post :comment
      end
      member do        
        get :upvote
        get :downvote
      end
    end
  end

  namespace :admin do
    root to: "homes#index"
    get "homes" => "homes#index"
    resources :company_details do
      member do
        get :approve
        post :reject
        get :pending
      end
      collection do
        get :featureds
      end
    end
    resources :events
    resources :jobs do
      member do
        get :approve
        post :reject
        get :pending
      end
    end
    resources :testimonials do
      member do
        get :approve
        post :reject
        get :pending
      end
    end
    resources :users
  end

  get "homes" => "homes#index"
  get "company_hub" => "homes#company_hub", :as => "homes_company_hub"
  get "career_info" => "homes#career_info", :as => "homes_career_info"
  get "about" => "homes#about", :as => "homes_about"
  get "terms" => "homes#terms", :as => "homes_terms"
  get "privacy" => "homes#privacy", :as => "homes_privacy"
  get "faq" => "homes#faq", :as => "homes_faq"
  get "contact" => "homes#contact", :as => "homes_contact"
  root to: "homes#index"

  # The priority is based upon order of creation:
  # first created -> highest priority.

  # Sample of regular route:
  #   match 'products/:id' => 'catalog#view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   match 'products/:id/purchase' => 'catalog#purchase', :as => :purchase
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Sample resource route with options:
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

  # Sample resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Sample resource route with more complex sub-resources
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', :on => :collection
  #     end
  #   end

  # Sample resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end

  # You can have the root of your site routed with "root"
  # just remember to delete public/index.html.
  # root :to => 'welcome#index'

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id))(.:format)'
end
