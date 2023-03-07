class CardComponentPreview < ViewComponent::Preview
  def card
    render(CardComponent.new(data: {fancy: :pants}, classes: "m-2")) do
      <<~HTML.chomp.html_safe # rubocop:disable Rails/OutputSafety
        <h3 class='p-2'>Hey There</h3>

        <p class='p-2'>You can put stuff in me!</p>
      HTML
    end
  end
end
