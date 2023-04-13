module Buttons
  class SecondaryComponentPreview < ViewComponent::Preview
    def test
      render(Buttons::SecondaryComponent.new(
        label: "This is the label",
        title: "And this is the title",
        href: "#"
      ))
    end
  end
end
