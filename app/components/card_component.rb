class CardComponent < ApplicationComponent
  attr_accessor :media
  FULL_WIDTH_16_BY_9 = [1290, 726]

  def initialize(media:, **kwargs)
    super(**kwargs)

    self.media = media&.variant(resize_to_fill: FULL_WIDTH_16_BY_9)
  end

  HEADER_VARIANTS = {
    default: "p-2 sm:p-4",
    no_padding: ""
  }
  renders_one :header, ->(variant: :default, &block) {
    content_tag(:header, class: HEADER_VARIANTS.fetch(variant), &block)
  }

  DEFAULT_FOOTER = "bg-slate-50 p-2 sm:p-4"
  FOOTER_VARIANTS = {
    default: DEFAULT_FOOTER,
    action_bar: [DEFAULT_FOOTER, "flex flex-row justify-between"].join(" ")
  }
  renders_one :footer, ->(variant: :default, &block) {
    classes = FOOTER_VARIANTS.fetch(variant)
    classes += " rounded-t-none" unless content? || header?
    content_tag(:footer, class: classes, &block)
  }
end
