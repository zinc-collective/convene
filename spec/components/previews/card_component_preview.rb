class CardComponentPreview < ViewComponent::Preview
  def card
    render(CardComponent.new(data: {fancy: :pants}, classes: "m-2")) do
      <<~HTML.chomp.html_safe # rubocop:disable Rails/OutputSafety
        <h3 class='p-2'>Hey There</h3>

        <p class='p-2'>You can put stuff in me!</p>
      HTML
    end
  end

  def card_with_footer
    render(CardComponent.new(data: {extreme: :hardcore})) do |card|
      card.with_footer { "Some footer content" }
      <<~HTML.chomp.html_safe # rubocop:disable Rails/OutputSafety
        <p>Some card content.</p>
      HTML
    end
  end
end
