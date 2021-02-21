Rails.application.routes.draw do
  passwordless_for :people

  namespace :admin do
    resources :spaces
    resources :clients
    resources :people
    resources :space_memberships
    resources :room_ownerships
    resources :rooms

    root to: 'spaces#index'
  end

  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  resources :spaces do
    resources :invitations, only: [:create, :destroy]
    resources :rooms, only: %i[show edit update] do
      resource :waiting_room, only: %i[show update]
      namespace :furniture do
        Furniture.append_routes(self)
      end
    end
  end

  match '/workspaces/*path', to: redirect('/spaces/%{path}'), via: [:GET]

  resources :guides, only: %i[index show]

  constraints BrandedDomain.new(Space) do
    root 'spaces#show'
    get '/:id', to: 'rooms#show'
  end
end
