Rails.application.routes.draw do
  get 'sessions/new'

  root 'static_pages#home'
  get '/signup', to: 'users#new'
  
  # ログイン機能
  get    '/login', to: 'sessions#new'
  post   '/login', to: 'sessions#create'
  delete '/logout', to: 'sessions#destroy'
  
  resources :users do
    member do #　memberブロックをリソースブロックに追加することでリソースにルーティングが追加される
      get 'edit_basic_info'
      patch 'update_basic_info'
      get 'attendances/edit_one_month' # Usersリソースに含まれるように設定したが、attendancesと記述することによってこのようなルーティングの設定が可能となる
      patch 'attendances/update_one_month'
      get 'attendances/edit_overwork_request'
      patch 'attendances/update_overwork_request'
    end
    resources :attendances, only: :update # onlyを付けてupdateアクション以外のルーティングを制限する
  end
end
