# frozen_string_literal: true

# A {Utility} is how we connect the broader Internet to a Space.
#
# @see features/utilities.feature
class Utility
  include ActiveModel::Model
  include ActiveModel::Attributes
  include ActiveModel::AttributeAssignment
  include ActiveModel::Validations
  # @return [UtilityHookup]
  attr_accessor :utility_hookup

  # @return [Space]
  delegate :space, to: :utility_hookup

  def configuration
    @configuration ||= utility_hookup&.configuration || {}
  end

  def form_template
    "#{self.class.name.demodulize.underscore}/form"
  end

  def display_name
    model_name.human.titleize
  end
end
