class ApplicationController < ActionController::Base

  # TODO: When we begin to implement authentication, we'll want this to return an actual Person
  # @returns [nil, Person] The Person for whom we are building a response
  helper_method def current_person
    nil
  end
end
