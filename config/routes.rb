Rails.application.routes.draw do
  resources :enrollments do
    get :my_students, on: :collection
  end
  resources :lessons
  devise_for :users
  resources :courses do
      get :purchased, :pending_review, :created, :unapproved, on: :collection
      member do
        patch :approve
        patch :unapprove
      end
    resources :lessons
    resources :enrollments, only: [:new, :create]
  end
  root 'static_pages#landing_page'
  get 'privacy_policy', to: 'static_pages#privacy_policy'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  get 'activity', to: 'static_pages#activity'
  resources :users, only: [:index, :edit, :show, :update]
  get 'analytics', to: 'static_pages#analytics'

  namespace :charts do
    get 'users_per_day'
    get 'enrollments_per_day'
    get 'course_popularity'
    get 'money_makers'
  end
  #get 'charts/users_per_day', to: 'charts#users_per_day'
  #get 'charts/enrollments_per_day', to: 'charts#enrollments_per_day'
  #get 'charts/course_popularity', to: 'charts#course_popularity'
  #get 'charts/money_makers', to: 'charts#money_makers'
end
