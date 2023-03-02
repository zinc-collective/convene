# frozen_string_literal: true

namespace :release do
  desc "Ensures any post-release / pre-deploy behavior has occurred"
  task after_build: [:environment, "db:prepare"] do
    # @todo Delete after running in prod
    Marketplace::Order.all.find_each do |order|
      next unless order.deprecated_delivery_address.present?

      order.update(delivery_address: order.deprecated_delivery_address, deprecated_delivery_address: nil)
    end
    SystemTestSpace.prepare
  end
end
