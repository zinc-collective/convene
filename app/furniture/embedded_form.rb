class EmbeddedForm
  include Placeable

  def form_url=(form_url)
    settings['form_url'] = form_url
  end

  def form_url
    settings['form_url']
  end

  def attribute_names
    super + ['form_url']
  end
end