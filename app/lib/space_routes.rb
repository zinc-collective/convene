module SpaceRoutes
  def self.append_routes(router)
    router.resource :authenticated_session, only: %i[new create update destroy show]
    router.resources :invitations, only: %i[create destroy index] do
      router.resource :rsvp, only: %i[show update]
    end
    router.resources :rooms, only: %i[show edit update new create destroy] do
      Furniture.append_routes(router)
      router.resource :waiting_room, only: %i[show update]
      router.resources :furniture_placements, only: %i[create edit update destroy]
    end

    router.resources :utility_hookups

    router.resources :memberships, only: %I[index show destroy]
  end
end
