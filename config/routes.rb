Rails.application.routes.draw do
  root 'static_pages#home'

  devise_for :user, controllers: { registrations: 'registrations' }

  as :user do
    get 'login', to: 'devise/sessions#new'
    delete 'logout', to: 'devise/sessions#destroy'
  end

  get    '/help',    to: 'static_pages#help'
  get    '/about',   to: 'static_pages#about'
  get    '/contact-success',    to: 'static_pages#contact_success'

  get '/.well-known/acme-challenge/:id' => 'static_pages#letsencrypt'

  resources :portals,             only: [:create, :destroy]
  resources :markers,             only: [:create, :destroy]

  resources :memories do
    member do
      post :set_details
    end
  end

  resources :spheres do
    member do
      post :zoom
    end
  end
end
