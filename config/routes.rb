Rails.application.routes.draw do
  root 'static_pages#home'

  devise_for :user, controllers: { registrations: 'registrations' }
  as :user do
    get 'login', to: 'devise/sessions#new'
    delete 'logout', to: 'devise/sessions#destroy'
  end

  get    '/help',    to: 'static_pages#help'
  get    '/about',   to: 'static_pages#about'
  get    '/contact', to: 'static_pages#contact'
  get    '/demo',    to: 'static_pages#demo'

  get '/.well-known/acme-challenge/:id' => 'static_pages#letsencrypt'

  resources :users, only: [:edit]
  resources :account_activations, only: [:edit]
  resources :password_resets,     only: [:new, :create, :edit, :update]
  resources :memories
  resources :portals,             only: [:create, :destroy]
  resources :markers,             only: [:create, :destroy]

  resources :spheres do
    member do
      post :zoom
    end
  end
end
