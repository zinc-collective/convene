class ButtonComponentPreview < ViewComponent::Preview
  def test
    render(ButtonComponent.new(label: "Awooo!", title: "gaaa!", href: "#"))
  end
end
