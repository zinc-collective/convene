class CardComponent < ApplicationComponent
  attr_accessor :wrapper_classes

  renders_one :header
  attr_accessor :header_classes

  attr_accessor :content_classes

  renders_one :footer
  attr_accessor :footer_classes

  def initialize(header_classes: "", content_classes: "", wrapper_classes: "", **kwargs)
    super(**kwargs)
  end
end
