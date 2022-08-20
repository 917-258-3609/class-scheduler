Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
  resources :schedules, only: %i[index show edit update]
  resources :students
  resources :subject_levels, only: %i[new create destroy]
  resources :subjects, only: %i[ show ]
  resources :teachers
  resources :courses
  root "schedules#index"
end
