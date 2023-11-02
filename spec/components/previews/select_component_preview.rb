# frozen_string_literal: true

class SelectComponentPreview < ViewComponent::Preview
  def default
    render(SelectComponent.new)
  end
end
