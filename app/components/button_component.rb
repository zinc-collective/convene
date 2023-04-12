# frozen_string_literal: true

class ButtonComponent < ApplicationComponent
  def initialize(
    label:,
    href:,
    title: nil,
    method: :put,
    confirm: nil,
    disabled: false,
    turbo_stream: false,
    **kwargs
  )
    @label = label
    @title = title
    @href = href
    @method = method
    @confirm = confirm
    @disabled = disabled
    @turbo_stream = turbo_stream

    super(data: data, **kwargs)
  end

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
