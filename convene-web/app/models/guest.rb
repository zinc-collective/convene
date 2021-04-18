class Guest
  include ActiveModel::Attributes
  include ActiveModel::Serialization
  attribute :id, :string, default: :guest
  attribute :name, :string, default: "Guest"
  # TODO: Make feature test not dependent on email
  attribute :email, :string, default: "guest@example.com"
  attribute :avatar_url, :string, default: '/avatar.svg'

  def member_of?(_space)
    false
  end
end