# frozen_string_literal: true

# @todo Maybe we want to try?
# http://jsonapi-rb.org/guides/serialization/defining.html
class ApplicationSerializer
  attr_accessor :resource

  def initialize(resource)
    self.resource = resource
  end

  # @todo make this even more like JSON API?
  #       https://jsonapi.org/format/1.1/#fetching-resources-responses
  def to_json(*_args)
    {
      errors: resource.errors.map(&method(:error_json))
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
