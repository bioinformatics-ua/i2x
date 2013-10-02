I2x::Application.routes.draw do
  
  post "templates/start"
  get "templates/start"
  resources :templates

  resources :stds

  resources :variants

  get "delivery/get"
  get "delivery/go"
  devise_for :users
  root  'home#index'

  
  get "usecases/variome"
  get "usecases/management"
  get "usecases/medical"
  get "usecases/newborn"
  get "usecases/crm"
  get "usecases/index"
  get "sequences/diff"
  get "sequences/content"
  get "sequences/rules"
  get "sequences/template"
  get "sequences/full"
  get "architecture/models"
  get "architecture/components"
  get "architecture/flows"
  get "publications/automating"
  get "publications/wave"
  get "publications/framework"
  get "publications/template"
  get "publications/semantic"
  get "publications/rule"
  get "publications/content"
  get "publications/index"
  get "contact/index"
  get "reference/index"
  get "research/others"
  get "research/swot"
  get "research/comparison"
  
  # general index redirects
  get 'home'      => 'home/index'
  get 'reference' => 'reference/index'
  get 'usecases'  => 'useasecases/index' 

  get "home/index"

  # testing Postman routes
  get "postman/load/:publisher/:identifier", to: "postman#load"
  get "postman/go/:identifier", to: 'postman#go'
  get "postman/deliver"
  get "postman/:key", to: "postman#deliver"
  post "postman/:key", to: "postman#action"


  # i2x image hack
  get '/i2x/images/*all', to: redirect('/images/%{all}.png')

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
