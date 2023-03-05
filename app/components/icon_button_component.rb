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
    data = {turbo_method: @method, turbo: true}
    if @confirm.present?
      data[:turbo_confirm] = @confirm
      data[:confirm] = @confirm
    end
    data
  end
end
