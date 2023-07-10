class Journal
  class Routes
    def self.append_routes(router)
      router.resources :journals, module: "journal" do
        router.resources :entries
        router.resources :keywords, only: [:show]
      end
    end
  end
end
