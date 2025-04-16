Rails.application.routes.draw do
  resources :areas
  resources :expresses do
    collection do
      get 'deliver_market_detail'
      post 'deliver_market_detail'
      get 'query_mail_trace'
      post 'query_mail_trace'
      get 'zm_province_index'
      # get 'receiver_query'
    end
    member do
      get 'get_mail_trace'
      post 'get_mail_trace'
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
      get 'receipt_report'
      post 'receipt_report'
      post 'receipt_report_export'
      get 'deliver_province_report'
      post 'deliver_province_report'
      post 'deliver_prov_city_report_export'
      get 'deliver_city_report'
      get 'international_express_report'
      post 'international_express_report'
      post 'international_express_report_export'
      get 'zm_deliver_report'
      post 'zm_deliver_report'
      post 'zm_deliver_report_export'
      get 'zm_operation_report'
      post 'zm_operation_report'
      post 'zm_operation_report_export'
      get 'zm_province_report'
      post 'zm_province_report'
      post 'zm_province_report_export'
      get 'zm_time_limit_report'
      post 'zm_time_limit_report'
      post 'zm_time_limit_report_export'
    end
  end

  resources :messages do 
    member do
      get 'details'
    end
  end

  resources :user_messages do
    collection do 
      post 'set_is_read'
    end
  end
  
  resources :countries

  resources :receiver_zones

  resources :international_expresses do
    collection do
      get 'import'
      post 'import' => 'international_expresses#import'
    end

    member do
      get 'get_mail_trace'
      post 'get_mail_trace'
    end
  end

  resources :import_files do
    member do 
      get 'download'
      post 'download' => 'import_files#download'
      get 'err_download'
      post 'err_download' => 'import_files#err_download'
    end
  end

  resources :air_mails do
    collection do
      get 'export'           #邮航进出口邮件导出
      post 'export'
      get 'ex_report'    #邮航出口邮件报表
      post 'ex_report'
      post 'ex_report_export' => 'air_mails#ex_report_export' #邮航出口邮件报表导出  
      get 'imp_report'    #邮航进口邮件报表
      post 'imp_report'
      post 'imp_report_export' => 'air_mails#imp_report_export' #邮航进口邮件报表导出 
      get 'imp_deliver_report'    #邮航进口投递报表
      post 'imp_deliver_report'
      post 'imp_deliver_report_export' => 'air_mails#imp_deliver_report_export' #邮航进口邮件报表导出 
    end
    member do
      get 'get_mail_trace'
      post 'get_mail_trace'
    end
  end

  # match "/reports/deliver_market_report" => "reports#deliver_market_report", via: [:get, :post]
  
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
