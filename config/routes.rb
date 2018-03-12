Rails.application.routes.draw do
  
  root to: "questions#index"
  
  devise_for :users
  resources :questions, only: [ :index, :show, :new, :create, :destroy, :update ] do
    resources :answers, shallow: true do
      member do
        post :choose_best
      end
    end
  end
end
