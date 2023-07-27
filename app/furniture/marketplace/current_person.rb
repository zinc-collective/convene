module Marketplace::CurrentPerson
  # Ensures the `current_person` helper method is from the `Marketplace` namespace,
  # so it can access things like `current_person.orders` or `current_person.shopper`
  def current_person
    super

    @current_person = if @current_person.is_a?(Marketplace::Person) || @current_person.is_a?(Marketplace::Guest)
      @current_person
    elsif @current_person.is_a?(Person)
      @current_person.becomes(Marketplace::Person)
    else
      Marketplace::Guest.new(session: session)
    end
  end
end
