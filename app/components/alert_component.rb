# frozen_string_literal: true

class AlertComponent < ApplicationComponent
  def initialize(
    scheme: :default,
    title: nil,
    icon: nil,
    **kwargs
  )
    @scheme = scheme
    @title = title
    @icon = icon

    super(data: data, **kwargs)
  end

  private

  def bg_class
    case @scheme
    when :warning
      "bg-yellow-50"
    when :danger
      "bg-red-50"
    when :success
      "bg-green-50"
    else
      "bg-stone-50"
    end
  end

  def icon_class
    case @scheme
    when :warning
      "text-yellow-400"
    when :danger
      "text-red-400"
    when :success
      "text-green-400"
    else
      "text-stone-400"
    end
  end

  def title_text_class
    case @scheme
    when :warning
      "text-yellow-800"
    when :danger
      "text-red-800"
    when :success
      "text-green-800"
    else
      "text-stone-800"
    end
  end

  def content_text_class
    case @scheme
    when :warning
      "text-yellow-700"
    when :danger
      "text-red-700"
    when :success
      "text-green-700"
    else
      "text-stone-700"
    end
  end
end
