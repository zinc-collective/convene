class StripeUtility < Utility
  def api_token=api_token
    configuration["api_token"] = api_token
  end

  def api_token
    configuration["api_token"]
  end
end
