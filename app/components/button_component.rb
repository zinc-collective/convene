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
    turbo: true,
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
    @turbo = turbo
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
    data = {turbo_method: @method, turbo: @turbo}
    data[:turbo_stream] = true if @turbo_stream
    if @confirm.present?
      data[:turbo_confirm] = @confirm
      data[:confirm] = @confirm
    end
    data
  end

  def base_classes
    ["button"]
  end

  def secondary_classes
    ["--secondary"]
  end

  def danger_classes
    ["--danger"]
  end

  def primary_classes
    ["--primary"]
  end
end
