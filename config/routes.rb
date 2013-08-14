TimeTracker::Application.routes.draw do
  root :to => "projects#index"

  get "static/index"
  get "static/legal"

  resources :activities do
    member do
      post :start
    end

    collection do
      get :all
    end
  end

  resources :current_activities do
    member do
      post 'adjust_start' => "current_activities#adjust_start", as: :adjust_start
      post :cancel, :restart
    end
  end

  resources :people do
    member do
      post :login, :logout, :reports, :project_position
      patch :time_zone
      get :reports
    end
  end

  resources :projects do
    member do
      post :start, :archive_toggle
    end

    collection do
      get :archived, :priority
    end
  end
end
