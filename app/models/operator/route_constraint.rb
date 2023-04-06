class Operator
  # Restricts a route to Operators
  # @see https://guides.rubyonrails.org/routing.html#specifying-constraints
  class RouteConstraint
    def matches?(request)
      return false unless request.session[:person_id]
      Person.find_by(id: request.session[:person_id])&.operator?
    end
  end
end
