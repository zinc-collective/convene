# frozen_string_literal: true

namespace :release do
  desc "Ensures any post-release / pre-deploy behavior has occurred"
  task after_build: [:environment, "db:prepare"] do
    # Put code you want to execute after migrations but before release here
    Marketplace::Product.connection.execute("SELECT id, description FROM marketplace_products").each do |result|
      Marketplace::Product.find(result["id"]).update(description: result["description"])
    end
  end
end
