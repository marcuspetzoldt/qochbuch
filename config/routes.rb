Qochbuch::Application.routes.draw do
  root 'landing_pages#home'
  resources :users
  resources :recipes
  get "landing_pages/help"
  get "landing_pages/about"
  match '/search', to: 'landing_pages#search', via: 'post'
  match '/next', to: 'landing_pages#next', via: 'get'
  match '/previous', to: 'landing_pages#previous', via: 'get'
  match '/signin', to: 'users#new', via: 'get', defaults: { what: 'signin' }
  match '/signup', to: 'users#new', via: 'get', defaults: { what: 'signup' }
  match '/signout', to: 'users#signout', via: 'delete'
  match '/change_password', to: 'users#change_password', via: 'patch'
  match '/upload', to: 'recipes#upload', via: ['post', 'patch']
  match '/recipes/:recipe_id/votes/:id/edit', to: 'votes#edit', via: 'get', as: 'recipes_votes_edit'
  match '/recipes/:id/calculate', to: 'recipes#calculate', via: 'patch', as: 'calculate'
# resources :users do
#   resources :recipes do
#     resources :votes
#   end
# end

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
