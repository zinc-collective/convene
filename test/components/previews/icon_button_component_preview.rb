# frozen_string_literal: true

class IconButtonComponentPreview < ViewComponent::Preview
  # @!group variants

  def enabled
    render(IconButtonComponent.new(
      label: "🤩",
      title: "Preview Button",
      href: "https://en.wikipedia.org/wiki/Emoji"
    ))
  end

  def disabled
    render(IconButtonComponent.new(
      label: "🤩",
      title: "Preview Button",
      href: "https://en.wikipedia.org/wiki/Emoji",
      disabled: true
    ))
  end

  def with_confirmation
    render(IconButtonComponent.new(
      label: "🤩",
      title: "Preview Button",
      href: "https://en.wikipedia.org/wiki/Emoji",
      confirm: true
    ))
  end

  # @!endgroup
end
