class SelectComponent < ApplicationComponent
  def initialize(config, **kwargs)
    @form = config[:form]
    @attribute = config[:attribute]
    @choices = config[:choices] || []
    @options = config[:options] || {}
    @html_options = config[:html_options] || {}
    @skip_label = config[:skip_label] || true

    super(**kwargs)
  end
end
