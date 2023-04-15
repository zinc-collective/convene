class Space
  class Agreement < ApplicationRecord
    extend StripsNamespaceFromModelName
    include RendersMarkdown

    self.table_name = "space_agreements"

    extend FriendlyId
    friendly_id :name, use: :slugged

    validates :name, presence: true, uniqueness: {scope: :space_id}
    validates :slug, uniqueness: {scope: :space_id}

    belongs_to :space, inverse_of: :agreements
    location(parent: :space)

    attribute :body, :string
    validates :body, presence: true

    def to_html
      render_markdown(body)
    end
  end
end
