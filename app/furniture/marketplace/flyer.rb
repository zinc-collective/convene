class Marketplace
  class Flyer
    attr_accessor :marketplace

    def initialize(marketplace)
      self.marketplace = marketplace
    end

    def vendor_name
      marketplace.room.name
    end

    def qr_code(uri)
      @qr_code ||= RQRCode::QRCode.new(uri)
    end

    def distributor_name
      marketplace.space.name
    end
  end
end
