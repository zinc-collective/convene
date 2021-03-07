class Guest
  include ActiveModel::Model
  attr_accessor :name, :email, :avatar_url

  def initialize(name: "Guest", email: "guest@example.com", avatar_url: "/avatar.svg")
    @name       = name
    @email      = email
    @avatar_url = avatar_url
  end
end
