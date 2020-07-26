# An organization or person paying for Convene to manage their virtual workspaces
class Client < ApplicationRecord
  # Human friendly description of the Client
  attribute :name, :string

  # URI-friendly description of the Client.
  attribute :slug, :string
  validates :slug, uniqueness: true

  # FriendlyId's does the legwork to make the slug uri-friendly
  extend FriendlyId
  friendly_id :name, use: :slugged

  # The workspaces the client owns
  has_many :workspaces, inverse_of: :client
end
