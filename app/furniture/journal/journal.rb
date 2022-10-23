class Journal::Journal < FurniturePlacement
  has_many :entries, inverse_of: :journal

  def self.model_name
    @_model_name ||= ActiveModel::Name.new(self, Journal)
  end

  def location
    [space, room, self]
  end
end
