# frozen_string_literal: true

Rails.application.routes.draw do
  root "spaces#show"

  resources :authentication_methods, only: %i[create]

  # get "/auth/:provider/callback", "sessions#create"
  # post "/auth/:provider/callback", "sessions#create"
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  resources :spaces, only: %I[show edit update create destroy] do
    resource :authenticated_session, only: %i[new create update destroy show]

    resources :invitations, only: %i[create destroy index] do
      resource :rsvp, only: %i[show update]
    end

    resources :rooms, only: %i[show edit update new create destroy] do
      Furniture.append_routes(self)
      resource :waiting_room, only: %i[show update]
      resources :furniture_placements, only: %i[create edit update destroy]
    end

    resources :utility_hookups

    resources :memberships, only: %I[index show destroy]
  end

  resources :memberships, only: %I[create]

  resource :me, only: %i[show], controller: "me"

  resources :guides, only: %i[index show]

  constraints DefaultSpaceConstraint.new(Space) do
    mount Rswag::Ui::Engine => "/api-docs"
    mount Rswag::Api::Engine => "/api-docs"
  end

  constraints BrandedDomainConstraint.new(Space) do
    get :edit, to: "spaces#edit"
    get "/" => "spaces#show"
    put "/" => "spaces#update"

    resources :invitations, only: %i[create destroy index] do
      resource :rsvp, only: %i[show update]
    end

    resources :memberships, only: %i[index show destroy]

    resources :utility_hookups, only: %I[create edit update destroy index]

    resource :authenticated_session, only: %i[new create update destroy show]

    resources :rooms, only: %i[show edit update new create destroy] do
      Furniture.append_routes(self)
    end
  end
end
