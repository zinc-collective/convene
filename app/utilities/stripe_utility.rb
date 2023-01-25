class StripeUtility < UtilityHookup
  def api_token=api_token
    configuration["api_token"] = api_token
  end

  def api_token
    configuration["api_token"]
  end

  def form_template
    "#{self.class.name.demodulize.underscore}/form"
  end

  def display_name
    model_name.human.titleize
  end
end
