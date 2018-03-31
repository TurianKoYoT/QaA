Rails.application.routes.draw do
  
  use_doorkeeper
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
  end

  resources :attachments, only: [ :destroy ]

  resources :votes, only: [ :create ]
  
  resources :comments, only: [ :create ]
  
  namespace :api do
    namespace :v1 do
      resources :profiles, only: [:index] do
        get :me, on: :collection
      end
    end
  end

  mount ActionCable.server => '/cable'
end
