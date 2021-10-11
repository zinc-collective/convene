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
        actor.member_of?(object.space)
      end

      def create?
        true
      end

      def permitted_attributes
        %i[payer_name payer_email amount memo public_token]
      end

      class Scope
        attr_accessor :actor, :scope

        def initialize(actor, scope)
          self.actor = actor
          self.scope = scope
        end

        def resolve
          scope.where(space: actor.spaces)
        end
      end
    end
  end
end
