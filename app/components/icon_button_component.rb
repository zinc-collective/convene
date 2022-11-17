# frozen_string_literal: true

class IconButtonComponent < ViewComponent::Base
  def initialize(
    label:,
    title:,
    href:,
    method: :put,
    confirm: false,
    disabled: false
  )
    @label = label
    @title = title
    @href = href
    @method = method
    @confirm = confirm
    @disabled = disabled
  end

  def data
    { turbo_method: @method, turbo: true, turbo_confirm: @confirm, confirm: @confirm }
  end
end
