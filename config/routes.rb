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
  patch "/schedule/:id/extend", to: "schedules#extend", as: "schedule_extend"
  patch "/schedule/:id/move", to: "schedules#move", as: "schedule_move"
  patch "/schedule/:id/postpone", to: "schedules#postpone", as: "schedule_postpone"
  get "/search/students", to: "students#search", as: "student_search"
  get "/search/teachers", to: "teachers#search", as: "teacher_search"
  get "/pay/:id", to: "users#payment", as: "user_pay"
  post "/pay/:id", to: "users#pay"
  root "schedules#index"
end
