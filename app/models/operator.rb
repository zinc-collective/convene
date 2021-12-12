class Operator
  include ActiveModel::Attributes
  include ActiveModel::Serialization
  attribute :id, :string, default: :operator
  attribute :name, :string, default: "Operator"

  def member_of?(_space)
    true
  end

  def operator?
    true
  end

  def authenticated?
    true
  end

  def spaces
    policy_scope(Space.all)
  end
end