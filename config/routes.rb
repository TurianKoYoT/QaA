require 'sidekiq/web'

Rails.application.routes.draw do
  
  use_doorkeeper

  authenticate :user, lambda { |u| u.admin? } do
    mount Sidekiq::Web => '/sidekiq'
  end

  root to: "questions#index"

  concern :votable do
    member do
      post :vote
      delete :destroy_vote
    end
  end
  
  concern :commentable do
    resources :comments, only: [ :create ]
  end
  
  devise_for :users, controllers: { omniauth_callbacks: 'omniauth_callbacks' }
  
  devise_scope :user do
    post :update_user, to: 'omniauth_callbacks#update_user'
  end

  resources :questions, only: [ :index, :show, :new, :create, :destroy, :update ], concerns: [:votable, :commentable] do
    resources :answers, shallow: true, concerns: [:votable, :commentable] do
      member do
        post :choose_best
      end
    end
    resources :subscriptions, only: [:create, :destroy], shallow: true
  end

  resources :attachments, only: [ :destroy ]

  resources :votes, only: [ :create ]
  
  resources :comments, only: [ :create ]
  
  namespace :api do
    namespace :v1 do
      resources :profiles, only: [:index] do
        get :me, on: :collection
      end
      resources :questions, only: [:index, :show, :create] do
        resources :answers, only: [:index, :show, :create], shallow: true
      end
    end
  end

  mount ActionCable.server => '/cable'
end
