module Furniture
  class CheckDropbox
    class CheckPolicy
      attr_accessor :object, :actor
      def initialize(actor, object)
        self.object = object
        self.actor = actor
      end

      def show?
        actor.member_of?(object.space)
      end
      
      alias_method :update?, :show?
      alias_method :edit?, :show?
      alias_method :destroy?, :show?


      def index?
        true
      end
      alias_method :create?, :index?

    end
  end
end