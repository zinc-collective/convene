class ApplicationComponent < ViewComponent::Base
  attr_accessor :data
  attr_writer :classes, :dom_id

  def initialize(data: {}, dom_id: nil, classes: "")
    self.data = data
    self.classes = classes
    self.dom_id = dom_id
  end

  # @todo this should gracefully merge left passed in data
  def attributes(classes: "")
    tag_builder.tag_options(id: dom_id, data: data, class: self.classes(classes))
  end

  # @todo how do we want to handle when tailwind is given conflicting classes? i.e. `mt-5 mt-3`
  def classes(others = "")
    "#{@classes} #{others}".strip.split.compact.uniq.join(" ")
  end

  def dom_id(*args, **kwargs)
    return @dom_id if @dom_id
    return if args.blank?
    super
  end
end
