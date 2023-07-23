class Marketplace
  module CurrentPerson
    def current_person
      super

      if @current_person.is_a?(Person) || @current_person.is_a?(Guest)
        return @marketplace_current_person = @current_person
      end

      @current_person = if @current_person.authenticated?
        @current_person.becomes(Person)
      else
        Guest.new(session: session)
      end
    end
  end
end
