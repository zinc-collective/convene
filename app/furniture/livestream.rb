# frozen_string_literal: true

# Renders a Twitch Livestream in a Room
class Livestream < FurniturePlacement
  def channel=(channel)
    settings["channel"] = channel
  end

  def channel
    settings.fetch("channel", "")
  end

  def provider=(provider)
    settings["provider"] = provider
  end

  def provider
    settings.fetch("provider", "twitch")
  end

  def layout=(layout)
    settings["layout"] = layout
  end

  def layout
    settings.fetch("layout", "")
  end

  def form_template
    "livestreams/form"
  end

  # @todo can we make it so we don't need to define this?
  # and the `settings.fetch` bits?
  def attribute_names
    %w[channel layout provider]
  end
end
