class Journal::Journal < FurniturePlacement
  extend StripsNamespaceFromModelName
  has_many :entries, inverse_of: :journal, dependent: :destroy

  def location
    [space, room, self]
  end
end
