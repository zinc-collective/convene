class CardComponent < ViewComponent::Base
  attr_accessor :data

  def initialize(data: {})
    self.data = data
  end

  def data_attributes
    @data_attributes ||= tag_builder.tag_options(data: data)&.html_safe
  end
end
