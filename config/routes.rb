Rails.application.routes.draw do
  get 'users/index'
  devise_for :users
  resources :books
  resources :users
  root 'users#index'
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"

  # gem letter_opener setting
  mount LetterOpenerWeb::Engine, at: '/letter_opener' if Rails.env.development?
end
