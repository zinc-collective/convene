# frozen_string_literal: true

class ButtonComponent < ApplicationComponent
  SCHEME_MAPPINGS = {
    primary: :primary_classes,
    secondary: :secondary_classes,
    danger: :danger_classes
  }.with_indifferent_access.freeze

  def initialize(
    label:,
    href:,
    icon: nil,
    title: nil,
    method: :put,
    confirm: nil,
    disabled: false,
    turbo_stream: false,
    scheme: nil,
    **kwargs
  )
    @label = label
    @title = title
    @href = href
    @icon = icon
    @method = method
    @confirm = confirm
    @disabled = disabled
    @turbo_stream = turbo_stream
    @scheme = scheme

    super(data: data, **kwargs)
  end

  private

  def classes
    if @scheme.present?
      (base_classes + send(SCHEME_MAPPINGS[@scheme])).join(" ")
    else
      super
    end
  end

  def data
    data = {turbo_method: @method, turbo: true}
    data[:turbo_stream] = true if @turbo_stream
    if @confirm.present?
      data[:turbo_confirm] = @confirm
      data[:confirm] = @confirm
    end
    data
  end

  def base_classes
    [
      "rounded-md",
      "px-3.5",
      "py-2.5",
      "text-sm",
      "font-semibold",
      "shadow-sm",
      "ring-1",
      "ring-inset",
      "text-center",
      "no-underline",
      "focus-visible:outline",
      "focus-visible:outline-2",
      "focus-visible:outline-offset-2",
      "focus-visible:outline-purple-600"
    ]
  end

  def secondary_classes
    [
      "bg-white",
      "text-purple-950",
      "ring-gray-300",
      "hover:bg-purple-100",
      "hover:text-purple-700"
    ]
  end

  def danger_classes
    [
      "bg-danger-500",
      "hover:bg-danger-700",
      "active:bg-danger-200",
      "text-white"
    ]
  end

  def primary_classes
    [
      "bg-purple-600",
      "text-white",
      "hover:bg-purple-700",
      "hover:text-white"
    ]
  end
end
