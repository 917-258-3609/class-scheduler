Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
  resources :schedules
  resources :students
  resources :subject_levels, only: [:index, :new, :create, :destroy]
  root "schedules#index"
end
