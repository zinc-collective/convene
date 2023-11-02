class SelectComponent < ApplicationComponent
  def initialize(config, **kwargs)
    @form = config[:form]
    @attribute = config[:attribute]
    @choices = config[:choices] || []
    @options = config[:options] || {}
    @html_options = config[:html_options] || {}
    @include_blank = config[:include_blank] || false
    @skip_label = config[:skip_label] || true
    @prompt = config[:prompt] || false

    super(**kwargs)
  end
end
