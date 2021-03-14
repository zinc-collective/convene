class Guest
  include ActiveModel::Attributes
  include ActiveModel::Serialization
  attribute :name, :string, default: "Guest"
  # Wait, do we want an email on guest? It's not a real person; so having an email address seems misleading..
  attribute :email, :string, default: "guest@example.com"

  attribute :avatar_url, :string, default: '/avatar.svg'
end