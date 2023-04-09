class SvgComponent < ApplicationComponent
  def call
    content_tag :svg, content, options
  end

  private

  def options
    super.merge({
      :fill => "none",
      :viewBox => "0 0 24 24",
      "stroke-width" => "1.5",
      :stroke => "currentColor",
      "aria-hidden" => true
    })
  end
end
