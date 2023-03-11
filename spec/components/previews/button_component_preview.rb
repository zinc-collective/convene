class ButtonComponentPreview < ApplicationPreview
  def test
    render(component(:button, label: "Awooo!", title: "gaaa!", href: "#"))
  end
end
