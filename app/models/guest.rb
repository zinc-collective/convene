class Guest
  include ActiveModel::Model
  include ActiveModel::Attributes
  include ActiveModel::Serialization
  attribute :id, :string, default: :guest
  attribute :name, :string, default: "Guest"
  # TODO: Make feature test not dependent on email
  attribute :email, :string, default: "guest@example.com"

  attribute :session

  def member_of?(_space)
    false
  end

  def operator?
    false
  end

  def authenticated?
    false
  end

  def spaces
    []
  end

  def rooms
    []
  end
end
