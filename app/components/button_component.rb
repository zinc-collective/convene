# frozen_string_literal: true

class ButtonComponent < ViewComponent::Base
  def initialize(
    label:,
    title:,
    href:,
    method: :put,
    confirm: nil,
    disabled: false,
    classes: nil
  )
    @label = label
    @title = title
    @href = href
    @method = method
    @confirm = confirm
    @disabled = disabled
    @classes = classes
  end

  attr_accessor :classes

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
