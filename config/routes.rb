Rails.application.routes.draw do
  # 芋煮チェーン機能
  resources :imoni_chains, only: [:index, :show, :new, :create] do
    collection do
      get :gacha  # ガチャページ
      post :spin  # ガチャ実行
    end
  end
  # 芋煮ケーションアプリのルート
  root 'home#index'

  # ホームコントローラー（トップページ）
  get 'home', to: 'home#index'

  # 質問ページ（3ステップ）
  get 'questions/step1', to: 'questions#step1'
  get 'questions/step2', to: 'questions#step2'
  get 'questions/step3', to: 'questions#step3'
  get 'questions/result', to: 'questions#result'
  get 'questions/respect', to: 'questions#respect'

  # 投票機能
  resources :votes, only: [:create]

  # 旧postリソース（必要に応じて削除可能）
  resources :posts

  # システムルート
  get "up" => "rails/health#show", as: :rails_health_check
  get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker
  get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
end
