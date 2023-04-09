# frozen_string_literal: true

class ButtonComponent < ViewComponent::Base
  attr_accessor :margin, :padding, :shape, :typography, :color, :animation

  def initialize(
    label:,
    title:,
    href:,
    method: :put,
    confirm: nil,
    disabled: false,
    animation: "transition ease-in-out duration-150",
    color: "bg-transparent bg-transparent hover:bg-primary-100 text-gray-700",
    margin: "my-1",
    padding: "py-2 px-4",
    typography: "no-underline text-center font-bold",
    shape: "rounded",
    turbo_stream: false
  )
    @label = label
    @title = title
    @href = href
    @method = method
    @confirm = confirm
    @disabled = disabled
    self.animation = animation
    self.color = color
    self.margin = margin
    self.padding = padding
    self.shape = shape
    self.typography = typography
    @turbo_stream = turbo_stream
  end

  def classes
    [animation, color, margin, padding, shape, typography].compact.join(" ")
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
