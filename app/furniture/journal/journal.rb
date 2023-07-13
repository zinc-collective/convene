class Journal::Journal < Furniture
  location(parent: :room)

  extend StripsNamespaceFromModelName
  has_many :entries, inverse_of: :journal, dependent: :destroy
  has_many :keywords, inverse_of: :journal, dependent: :destroy
end
