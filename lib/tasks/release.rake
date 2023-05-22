# frozen_string_literal: true

namespace :release do
  desc "Ensures any post-release / pre-deploy behavior has occurred"
  task after_build: [:environment, "db:prepare"] do
    Marketplace::TaxRate.all.find_each do |tax_rate|
      if tax_rate.marketplace.blank?
        Marketplace::ProductTaxRate.where(tax_rate: tax_rate).each(&:destroy!)
        tax_rate.destroy!
        next
      end
      tax_rate.update!(bazaar: tax_rate.marketplace.bazaar)
    end
  end
end
