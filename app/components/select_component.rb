class SelectComponent < ApplicationComponent
  def initialize(config, **)
    @form = config.fetch(:form)
    @attribute = config.fetch(:attribute)
    @choices = config.fetch(:choices, [])
    @options = config.fetch(:options, {})
    @html_options = config.fetch(:html_options, {})
    @skip_label = config.fetch(:skip_label, true)
    @label_hint = config.fetch(:label_hint, "")

    super(**)
  end
end
