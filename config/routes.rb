Rails.application.routes.draw do
  Blacklight::Marc.add_routes(self)
  root to: "catalog#index"

  blacklight_for :catalog
  devise_for :users

  get "shelf/nearby", to: "shelf#nearby", as: "shelf_nearby"
  get "browse/fondslist", to: "browse#fondslist", as: "browse_fondslist"

  get "collections", to: "browse#collections", as: "list_collections"

  get "browse/authors", to: "browse#authors", as: "browse_authors"
  get "browse/directors", to: "browse#directors", as: "browse_directors"
  get "browse/languages", to: "browse#languages", as: "browse_languages"
  get "browse/library_collections", to: "browse#library_collections", as: "browse_library_collections"
  get "browse/av_collections", to: "browse#av_collections", as: "browse_av_collections"
  get "browse/digital_collections", to: "browse#digital_collections", as: "browse_digital_collections"

  get "db/fa/:lookup", to: "falookup#lookup", as: "falookup_lookup"
  get "falist/:id", to: "falist#index", as: "falist_index"

  get "vis/dr_timeline/data/:collection/:year/:month", to: "drtimeline#get_data_by_date", as: "drtimeline_data_by_date"
  get "vis/dr_timeline/data/:collection/dates", to: "drtimeline#get_dates_for_collection", as: "drtimeline_dates_for_collection"
  get "vis/dr_timeline", to: "drtimeline#index", as: "drtimeline_index"

  get "browse/privacy_policy", to: "browse#privacy_policy", as: "privacy_policy"

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
