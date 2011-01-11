Webistrano::Application.routes.draw do
  root :to => 'projects#dashboard'
  
  # TODO: where is this used? -- fd
  match ':controller/service.wsdl' => '#wsdl'
  
  resources :hosts
  
  resources :recipes do
    collection do
      get :preview
    end
  end

  resources :projects do
    resources :project_configurations
    resources :stages do
      resources :stage_configurations
      resources :roles
      resources :deployments do
        collection do
          get :latest
        end
        member do
          post :cancel
        end
      end
    end
  end

  resources :users do
    member do
      post :enable
      get :deployments
    end
  end

  resources :sessions do
    collection do
      get :version
    end
  end

  match '/signup' => 'users#new', :as => :signup
  match '/login' => 'sessions#new', :as => :login
  match '/logout' => 'sessions#destroy', :as => :logout
  match '/stylesheets/application.css' => 'stylesheets#application', :as => :stylesheet
  
  # match '/:controller(/:action(/:id))'
end
