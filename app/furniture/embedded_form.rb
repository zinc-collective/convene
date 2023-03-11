# frozen_string_literal: true

class EmbeddedForm < Furniture
  def form_url=(form_url)
    settings["form_url"] = form_url
  end

  def form_url
    settings["form_url"]
  end

  def embeddable_form_url
    form_id = form_url
      .gsub("https://airtable.com/", "")
      .gsub("/embed", "")
      .gsub("embed/", "")

    "https://airtable.com/embed/#{form_id}"
  end

  def attribute_names
    ["form_url"]
  end

  def form_template
    "embedded_forms/form"
  end
end
