# frozen_string_literal: true

class Marketplace::Tag::AdminComponentPreview < ViewComponent::Preview
  def default
    render(Marketplace::Tag::AdminComponent.new)
  end
end
