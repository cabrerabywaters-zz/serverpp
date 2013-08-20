require 'sidekiq/web'
require 'sidetiq/web'

Showtime::Application.routes.draw do
  authenticate :admin do
    mount Sidekiq::Web => '/sidekiq'
  end

  devise_for :user_ecos

  devise_for :user_efis

  devise_for :admins


  namespace :puntos_point do

    resources :admins
    resources :categories
    resources :efis
    resources :industries

    get 'edit_percentage_industries' => "percentage_industries#edit",   as: :edit_percentage_industries
    put 'percentage_industries'      => "percentage_industries#update", as: :percentage_industries

    resources :interests
    resources :user_efis

    resources :small_ecos # ECO chica
    resources :big_ecos   # ECO grande

    resources :user_ecos

    resources :experiences, only: [:index, :show, :destroy] do
      member do
        put :bill
        put :pay
      end
    end
    resources :experience_steps, only: [:index, :show, :update]

    resources :events, only: :index do
      member do
        put :bill
        put :pay
      end
    end

    root :to => 'admins#index'
  end

  namespace :eco do
    resources :user_ecos, only: [:edit, :update]

    resources :experiences, only: [:index, :show, :destroy]
    resources :experience_steps, only: [:index, :show, :update]


    get  "experiences/:id/purchases" => "purchases#index", as: :experience_purchases
    post "experiences/:id/purchases/validate/" => "purchases#validate", as: :validate_purchase

    get "incomes" => "incomes#index", as: :incomes

    resources :publicities, only: [:index, :show] do
      member do
        put :accept
        put :reject
      end
    end

    root :to => 'experiences#index'
  end

  namespace :efi do
    resources :experiences, only: [:index, :show] do
      resources :events, only: :create
    end
    resources :events, only: [:index, :show] do
      member do
        put :publish
        put :unpublish
      end
    end

    resources :trades, except: [:index, :show, :create, :new, :update, :destroy, :edit] do
      collection do
        get :category
        get :efi
      end
    end

    resources :interests, only: :index

    resources :user_efis, only: [:edit, :update]

    resources :accounts
    resources :banners
    resources :publicities, only: [:index, :show, :new, :create, :destroy]

    resources :api, only: :index do
      collection do
        post :generate
      end
    end

    get "summary" => "summary#index", as: :summary

    root :to => 'experiences#index'
  end

  namespace :api do
    namespace :cmr do
      wash_out :events
      wash_out :purchases
    end
  end


  # TODO - eliminar luego de refactorizar
  match "empresa/:corporative_id"                          => "corporative/events#index",     as: :corporative_root
  match "empresa/:corporative_id/events"                   => "corporative/events#index",     as: :corporative_events
  match "empresa/:corporative_id/events/:id"               => "corporative/events#show",      as: :corporative_event
  match "empresa/:corporative_id/events/:id/purchases/new" => "corporative/purchases#new",    as: :new_corporative_purchase
  post  "empresa/:corporative_id/events/:id/purchases"     => "corporative/purchases#create", as: :corporative_purchases
  get   "empresa/:corporative_id/purchases/:id"            => "corporative/purchases#show",   as: :corporative_purchase

  post "empresa/:corporative_id/points" => "corporative/points#create", as: :corporative_point
end
