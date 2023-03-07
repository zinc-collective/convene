class ApplicationComponent < ViewComponent::Base
  attr_accessor :data
  attr_writer :classes

  def initialize(data: {}, classes: "")
    self.data = data
    self.classes = classes
  end

  # @todo this should gracefully merge left passed in data
  def attributes(classes: "")
    tag_builder.tag_options(data: data, class: self.classes(classes))
  end

  # @todo how do we want to handle when tailwind is given conflicting classes? i.e. `mt-5 mt-3`
  def classes(others = "")
    "#{@classes} #{others}".strip.split.compact.uniq.join(" ")
  end
end
