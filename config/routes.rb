# frozen_string_literal: true

Rails.application.routes.draw do
  root "spaces#show"

  resources :authentication_methods, only: %i[create]

  # get "/auth/:provider/callback", "sessions#create"
  # post "/auth/:provider/callback", "sessions#create"
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  resources :spaces, only: %I[show edit update create destroy] do
    SpaceRoutes.append_routes(self)
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

    SpaceRoutes.append_routes(self)
  end
end
