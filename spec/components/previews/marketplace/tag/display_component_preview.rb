# frozen_string_literal: true

class Marketplace::Tag::DisplayComponentPreview < ViewComponent::Preview
  def default
    render(Marketplace::Tag::DisplayComponent.new)
  end
end
