Rails.application.routes.draw do
  
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
  
  devise_for :users
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
  
  mount ActionCable.server => '/cable'
end
