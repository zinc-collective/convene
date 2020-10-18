

Rails.application.routes.draw do
  namespace :admin do
      resources :workspaces
      resources :clients
      resources :people
      resources :workspace_memberships
      resources :room_ownerships
      resources :rooms

      root to: "workspaces#index"
    end
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  resources :workspaces do
    resources :rooms do
      resource :waiting_room, only: [:show, :update]
    end
  end
  constraints BrandedDomain.new(Workspace) do
    root 'workspaces#show'
    get "/:id", to: 'rooms#show'
  end
end