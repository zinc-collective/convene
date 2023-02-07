class Journal
  class Routes
    def self.append_routes(router)
      router.resources :journals do
        router.resources :entries, module: "journal"
      end
    end
  end
end
