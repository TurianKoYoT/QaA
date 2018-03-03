Rails.application.routes.draw do
  
  root to: "questions#index"
  
  devise_for :users
  resources :questions, only: [ :index, :show, :new, :create, :destroy ] do
    resources :answers, shallow: true
  end
end
