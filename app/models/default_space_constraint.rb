# Expose routes only when directing to the DefaultSpace
class DefaultSpaceConstraint < BrandedDomainConstraint
  # @return [TrueClass,FalseClass]
  def matches?(request)
    return true unless space_for_request(request).present?
    space_for_request(request).slug == ENV['DEFAULT_SPACE']
  end
end