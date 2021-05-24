Rails.application.routes.draw do
  root 'spaces#show'

  namespace :admin do
    resources :spaces
    resources :clients
    resources :people
    resources :space_memberships
    resources :room_ownerships
    resources :rooms

    root to: 'spaces#index'
  end

  # get "/auth/:provider/callback", "sessions#create"
  # post "/auth/:provider/callback", "sessions#create"
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  resources :spaces, only: %I[show edit update] do
    resource :authenticated_session, only: %i[new create destroy show]

    resources :rooms, only: %i[show edit update] do
      resource :waiting_room, only: %i[show update]
      resources :furniture_placements, only: [:update]
      namespace :furniture do
        Furniture.append_routes(self)
      end
    end

    resources :utility_hookups, only: %I[create edit update destroy index]
  end

  resource :me, only: %i[show], controller: 'me'

  match '/workspaces/*path', to: redirect('/spaces/%<path>'), via: [:GET]

  resources :guides, only: %i[index show]

  constraints BrandedDomain.new(Space) do
    resources :authenticated_sessions, only: %i[new create delete show]

    get '/:id', to: 'rooms#show'
  end
end
