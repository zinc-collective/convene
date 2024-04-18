class ApplicationComponent < ViewComponent::Base
  attr_accessor :data
  attr_writer :classes, :dom_id
  include Turbo::FramesHelper
  delegate :policy_scope, to: :helpers

  def initialize(data: {}, dom_id: nil, classes: "", current_person: nil)
    self.data = data
    self.classes = classes
    self.dom_id = dom_id
    self.current_person = current_person
  end

  def attributes(classes: "")
    tag_builder.tag_options(options(extra_classes: classes))
  end

  # @todo this should gracefully merge left passed in data
  def options(extra_classes: "")
    {data: data, class: classes(extra_classes), id: dom_id}
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

  def policy(*, **)
    Pundit.policy(current_person, *, **)
  end

  # Gives components access to the current user on application context which is
  # not automatically shared across ApplicationController and ViewComponent::Base
  attr_writer :current_person
  def current_person
    @current_person ||= helpers.current_person
  end

  def edit_button(title:, href:, label: "#{t("icons.edit")} #{t("edit.link_to")}")
    ButtonComponent.new label: label, title: title,
      href: href, turbo_stream: true, method: :get, scheme: :secondary
  end
end
