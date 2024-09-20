# frozen_string_literal: true

require "sidekiq/web"

Rails.application.routes.draw do
  mount Lookbook::Engine, at: "/components"

  resources :authentication_methods, only: %i[create]
  resource :authenticated_session, only: %i[new create update destroy show]

  # get "/auth/:provider/callback", "sessions#create"
  # post "/auth/:provider/callback", "sessions#create"
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  resources :spaces, only: %I[new create show edit update create destroy] do
    SpaceRoutes.append_routes(self)
  end

  resources :memberships, only: %I[create]

  resource :me, only: %i[show], controller: "me"

  constraints BrandedDomainConstraint.new(Space) do
    get :edit, to: "spaces#edit"
    get "/" => "spaces#show"
    put "/" => "spaces#update"

    SpaceRoutes.append_routes(self)
  end

  root "neighborhoods#show"
  mount Sidekiq::Web => "/sidekiq", :constraints => Operator::RouteConstraint.new
end
