# frozen_string_literal: true

# Renders a Twitch Livestream in a Room
class Livestream < Furniture
  setting :channel, default: ""
  setting :layout, default: ""
  setting :provider, default: "twitch"

  def form_template
    "livestreams/form"
  end

  # @todo can we make it so we don't need to define this?
  # and the `settings.fetch` bits?
  def attribute_names
    %w[channel layout provider]
  end
end
