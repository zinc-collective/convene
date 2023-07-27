class Marketplace
  class Guest < ::Guest
    attr_writer :shopper
    def shopper
      @shopper ||= Shopper.find_by(id: session[:guest_shopper_id])
    end

    def find_or_create_shopper
      @shopper ||= Shopper.find_or_create_by(id: session[:guest_shopper_id] ||= SecureRandom.uuid)
    end
  end
end
