MasterClassNB::Application.routes.draw do
  get "teacher_subjects/index"
  get "teacher_subjects/show"
  get "teacher_subjects/new"
  get "teacher_subjects/create"
  get "teacher_subjects/edit"
  get "teacher_subjects/destroy"
  get "teacher_subjects/update"
  get "sessions/create"
  get "sessions/destroy"
  get "register_subjects/index"
  get "register_subjects/edit"
  get "register_subjects/create"
  get "subject/new"
  get "subject/index"
  get "subject/edit"
  get "subject/create"
  get "programs/create"
  get "programs/new"
  get "programs/index"
  get "programs/edit"
  get "semesters/new"
  get "semesters/index"
  get "semesters/edit"
  get "semesters/show"
  get "semesters/create"
  root 'users#index'
  get "users/new"
  get "users/index"
  get "users/edit"
  get "users/show"
  
  resources :users
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
