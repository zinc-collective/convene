# @todo Maybe we want to try?
# http://jsonapi-rb.org/guides/serialization/defining.html
class AuthenticationMethod::Serializer
  # @return [AuthenticatioMethod]
  attr_accessor :authentication_method

  def initialize(authentication_method)
    @authentication_method = authentication_method
  end

  # @todo make this even more like JSON API?
  #       https://jsonapi.org/format/1.1/#fetching-resources-responses
  def to_json
    {
      errors: authentication_method.errors.map(&method(:error_json)),
      authentication_method: {
        id: authentication_method.id,
        contact_method: authentication_method.contact_method,
        contact_location: authentication_method.contact_location,
        person: {
          id: authentication_method.person.id
        }
      }
    }
  end

  private def error_json(error)
    {
      code: error.type,
      title: error.full_message,
      detail: error.message,
      source: {
        pointer: "/#{error.base.model_name.param_key}/#{error.attribute}"
      }
    }
  end
end