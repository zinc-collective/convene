

Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  resources :workspaces
  constraints BrandedDomain.new(Workspace) do
    root 'workspaces#show'
    get "/:id", to: 'rooms#show'
  end
end