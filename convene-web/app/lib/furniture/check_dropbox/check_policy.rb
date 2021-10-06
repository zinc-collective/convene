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

      alias update? show?
      alias edit? show?
      alias destroy? show?

      def index?
        true
      end
      alias create? index?
    end
  end
end
