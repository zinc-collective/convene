# frozen_string_literal: true

class EmbeddedForm
  include Placeable

  def form_url=(form_url)
    settings['form_url'] = form_url
  end

  def form_url
    settings['form_url']
  end

  def embeddable_form_url
    form_id = form_url
              .gsub('https://airtable.com/', '')
              .gsub('/embed', '')
              .gsub('embed/', '')

    "https://airtable.com/embed/#{form_id}"
  end

  # @deprecated
  def in_room_template
    "#{self.class.furniture_kind}/in_room"
  end

  def attribute_names
    super + ['form_url']
  end
end
