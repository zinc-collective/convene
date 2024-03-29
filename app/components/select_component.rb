class SelectComponent < ApplicationComponent
  def initialize(config, **kwargs)
    @form = config.fetch(:form)
    @attribute = config.fetch(:attribute)
    @choices = config.fetch(:choices, [])
    @options = config.fetch(:options, {})
    @html_options = config.fetch(:html_options, {})
    @skip_label = config.fetch(:skip_label, true)

    super(**kwargs)
  end
end
