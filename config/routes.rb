Rails.application.routes.draw do
  resources :expresses do
    collection do
      get 'deliver_market_detail'
      post 'deliver_market_detail'
    end
  end

  root 'welcome#index'
  
  devise_for :users, controllers: { sessions: "users/sessions" }

  resources :user_logs, only: [:index, :show, :destroy]

  resources :units do
    collection do
      get 'import'
      post 'import' => 'units#import'
    end
    resources :users, :controller => 'unit_users'

    member do 
      # get 'index'
      get 'new_child_unit' => 'units#new'
      get 'child_units' => 'units#index'
      # get 'update_unit'
      # get 'destroy_unit'
    end
  end

  resources :users do
    member do
      get 'to_reset_pwd'
      patch 'reset_pwd'
      post 'lock' => 'users#lock'
      post 'unlock' => 'users#unlock'
    end
    resources :roles, :controller => 'user_roles'
  end

  resources :up_downloads do
    collection do 
      get 'up_download_import'
      post 'up_download_import' => 'up_downloads#up_download_import'
      
      get 'to_import'
      
      
    end
    member do
      get 'up_download_export'
      post 'up_download_export' => 'up_downloads#up_download_export'
    end
  end

  resources :businesses

  resources :reports do
    collection do
      get 'deliver_market_report'
      post 'deliver_market_report'
      post 'deliver_market_report_export'
      get 'deliver_unit_report'
      post 'deliver_unit_report'
      post 'deliver_unit_report_export'
      get 'deliver_market_monitor'
      post 'deliver_market_monitor'
      get 'deliver_unit_monitor'
      post 'deliver_unit_monitor'
      get 'court_deliver_market_report'
      post 'court_deliver_market_report'
      get 'court_deliver_unit_report'
      post 'court_deliver_unit_report'
      get 'court_deliver_market_monitor'
      post 'court_deliver_market_monitor'
      get 'court_deliver_unit_monitor'
      post 'court_deliver_unit_monitor'
      get 'business_market_report'
      post 'business_market_report_export'
    end
  end

  # match "/reports/deliver_market_report" => "reports#deliver_market_report", via: [:get, :post]
  
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
