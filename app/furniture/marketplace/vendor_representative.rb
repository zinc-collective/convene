class Marketplace
  class VendorRepresentative < Record
    self.table_name = :marketplace_vendor_representatives

    belongs_to :marketplace, inverse_of: :vendor_representatives
    has_one :room, through: :marketplace
    belongs_to :person, optional: true

    attribute :email_address, :string
    validates :email_address, uniqueness: true, presence: true

    location(parent: :marketplace)

    def claimed?
      person.present?
    end

    def claimable?
      !claimed? && matching_person.present?
    end

    def matching_person
      Person.joins(:authentication_methods).find_by(authentication_methods: {contact_location: email_address})
    end
  end
end
