Rails.application.routes.draw do
  match '/home',    to: 'static_pages#home',    via: 'get'
  match '/help',    to: 'static_pages#help',    via: 'get'
  resources :microposts
  resources :users
  root 'static_pages#home'
end
