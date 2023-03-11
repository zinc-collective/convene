class Journal::Journal < Furniture
  self.location_parent = :room

  extend StripsNamespaceFromModelName
  has_many :entries, inverse_of: :journal, dependent: :destroy
end
