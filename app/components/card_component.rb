class CardComponent < ApplicationComponent
  attr_accessor :media

  def initialize(media: nil, **kwargs)
    super(**kwargs)

    self.media = media
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

  def head_image
    media&.upload&.variant(resize_to_fill: Media::FULL_WIDTH_16_BY_9)
  end
end
