class Guest
  include ActiveModel::Attributes
  include ActiveModel::Serialization
  attribute :id, :string, default: :guest
  attribute :name, :string, default: "Guest"
  # TODO: Make feature test not dependent on email
  attribute :email, :string, default: "guest@example.com"

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
end