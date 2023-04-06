class Operator
  class RouteConstraint
    def matches?(request)

      return false unless request.session[:person_id]
      Person.find_by(id: request.session[:person_id])&.operator?
    end
  end
end
