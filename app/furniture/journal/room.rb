class Journal::Room < Room
  has_many :journal_entries, inverse_of: :room, class_name: "Journal::Entry"

  def self.model_name
    @model_name ||= ActiveModel::Name.new(self, Journal)
  end
end