module AuthHelpers
  def sign_in(person)
    # TODO: How do we make authentication work in rack-tests?
    raise NotImplementedError
  end
end

RSpec.configure do |config|
  config.include AuthHelpers
end
