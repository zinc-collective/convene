class Journal::Journal < FurniturePlacement
  extend StripsNamespaceFromModelName
  has_many :entries, inverse_of: :journal

  def location
    [space, room, self]
  end
end
