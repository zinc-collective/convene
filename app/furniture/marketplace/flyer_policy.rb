# frozen_string_literal: true

class Marketplace
  class FlyerPolicy < Policy
    alias_method :marketplace, :object
    def show?
      true
    end
  end
end
