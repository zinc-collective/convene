# frozen_string_literal: true

class IconButtonComponent < ViewComponent::Base
  def initialize(
    label:,
    title:,
    href:,
    method: :put,
    confirm: nil,
    disabled: false
  )
    @label = label
    @title = title
    @href = href
    @method = method
    @confirm = confirm
    @disabled = disabled
  end

  private

  def data
    data = { turbo_method: @method, turbo: true }
    data.merge!({ turbo_confirm: @confirm, confirm: @confirm }) if @confirm.present?
    data
  end
end
