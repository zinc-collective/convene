# frozen_string_literal: true

class ButtonComponent < ViewComponent::Base
  def initialize(
    label:,
    title:,
    href:,
    method: :put,
    confirm: nil,
    disabled: false,
    classes: nil,
    turbo_stream: false
  )
    @label = label
    @title = title
    @href = href
    @method = method
    @confirm = confirm
    @disabled = disabled
    @classes = classes
    @turbo_stream = turbo_stream
  end

  attr_accessor :classes

  private

  def data
    data = {turbo_method: @method, turbo: true}
    data[:turbo_stream] = true if @turbo_stream
    if @confirm.present?
      data[:turbo_confirm] = @confirm
      data[:confirm] = @confirm
    end
    data
  end
end
