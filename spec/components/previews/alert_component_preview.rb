# frozen_string_literal: true

class AlertComponentPreview < ViewComponent::Preview
  def default
    render(AlertComponent.new(title: "A note for you")) do
      <<~HTML.chomp.html_safe # rubocop:disable Rails/OutputSafety
        I just wanted to let you know!
      HTML
    end
  end

  def warning_with_icon
    render(AlertComponent.new(scheme: :warning, title: "Achtung", icon: :exclamation_triangle)) do
      <<~HTML.chomp.html_safe # rubocop:disable Rails/OutputSafety
        Watch out, I'm alerting <strong>you</strong> of something!
      HTML
    end
  end
end
