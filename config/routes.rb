Rails.application.routes.draw do
  
  devise_for :users

  get 'info/index'

  get 'tenders/index'



  get 'api/employee'
  get 'api/apartments'
  get 'api/objects'
  get 'api/tenders'
  get 'api/organizations'
  get 'api/claims'
  get 'api/gethash'
  get 'api/get_object_image'
  get 'api/photos_by_object'


  get 'object/getJSONData'
  get 'apartment/index'

  get 'object/index'
  get 'object/finance'
  get 'object/view'
  get 'object/overdue'
  get 'object/organizations'


  # get 'employee/vacancies'
  # post 'employee/vacancies'

  # get 'employee/vacancies_ed'
  # post 'employee/vacancies_ed'  

  get 'welcome/index'

  get 'employee/personalflowXmlParse'
  get 'employee/pfxmlp'
  get 'employee/salaryXmlParse'
  get 'employee/personalInit'
  get 'employee/vacancies'
  get 'employee/index'
  get 'employee/getEmployeeStats'

  get 'employee/editmanagment'
  post 'employee/editmanagment'

  get 'employee/calculate'
  get 'employee/salaryXMLChange'

  #get 'vacancies/show'
  #get 'vacancies/vacedit'
  #get 'vacancies/show', as: 'user_root'
  
  get 'vacancies/update'
  # post 'vacancies/vacupdate'


  get 'apartment/index'
  get 'apartment/index2'
  get 'api/getchart'

  get 'apartment/crm'

  get 'object/index'


  get 'tenders/index'
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


  namespace :api do
    namespace :v1 do
      resources :staffs, only: [:index] do  end
      resources :objects, only: [:index] do  end
      resources :contractors, only: [:index] do  end
      resources :object_photos, only: [:index] do  end
      resources :flats, only: [:index] do  end
    end

    namespace :v2 do
      resources :staffs, only: [:index] do  end
      resources :objects, only: [:index] do  end
      resources :objects2, only: [:index] do  end
      resources :contractors, only: [:index] do  end
      resources :object_photos, only: [:index] do  end
      resources :flats, only: [:index] do  end
    end
  end
  resource :vacancies
end
