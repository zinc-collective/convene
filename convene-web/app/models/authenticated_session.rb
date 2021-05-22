# Encapsulates interactions with {Rack::Session} and {AuthenticationMethod}
# to support signing in and out of Convene.
class AuthenticatedSession
  include ActiveModel::Model
  include ActiveModel::Validations

  attr_accessor :session, :space, :contact_method, :contact_location, :one_time_password

  validate :verify_one_time_password

  def person
    authentication_method.person
  end

  # @return [AuthenticationMethod]
  def authentication_method
    @authentication_method ||= AuthenticationMethod
      .find_or_initialize_by(contact_method: contact_method, contact_location: contact_location)
  end

  def authentication_method_id=(authentication_method_id)
    @authentication_method = AuthenticationMethod.find(authentication_method_id)
  end

  def persisted?
    false
  end

  def destroy
    session[:person_id] = nil
  end

  def save
    return false unless valid?

    if one_time_password.nil?
      authentication_method.send_one_time_password!(space)
      return false
    elsif authentication_method.verify?(one_time_password)
      session[:person_id] = authentication_method.person.id
      authentication_method.confirm!
      return true
    end

    false
  end

  def verify_one_time_password
    return if one_time_password.nil? || authentication_method.verify?(one_time_password)
    errors.add(:one_time_password, :invalid_one_time_password)
  end
end
