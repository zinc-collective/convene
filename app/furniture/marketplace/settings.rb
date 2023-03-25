# frozen_string_literal: true

class Marketplace
  class Settings
    include StoreModel::Model

    attribute :delivery_fee_cents, :integer, default: 0
    attribute :delivery_window, :datetime
    attribute :notify_emails, :string
    attribute :order_by, :string
    attribute :stripe_account, :string
    attribute :stripe_webhook_endpoint, :string
    attribute :stripe_webhook_endpoint_secret, :string
  end
end
