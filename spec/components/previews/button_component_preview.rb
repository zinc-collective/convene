class ButtonComponentPreview < ViewComponent::Preview
  def default
    render(ButtonComponent.new(
      label: "I'm a basic button with custom classes",
      title: "gaaa!",
      href: "#",
      classes: "font-bold bg-rose-500 text-white hover:text-red-50 p-5 no-underline"
    ))
  end

  def scheme_primary
    render(ButtonComponent.new(
      label: "I'm a primary button",
      title: "gaaa!",
      href: "#",
      scheme: :primary
    ))
  end

  def scheme_secondary
    render(ButtonComponent.new(
      label: "I'm a secondary button",
      title: "gaaa!",
      href: "#",
      scheme: :secondary
    ))
  end
end
