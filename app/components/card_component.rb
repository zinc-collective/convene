class CardComponent < ApplicationComponent
  renders_one :footer
  attr_accessor :image_url

  def initialize(image_url: nil, **kwargs)
    super(**kwargs)
    self.image_url = image_url
  end

  private

  def card_classes_content
    [
      "p-4",
      "sm:p-6"
    ].compact.join(" ")
  end

  def card_classes_wrapper
    [
      "shadow",
      "rounded-lg",
      "h-full",
      "bg-white",
      "group-hover:bg-slate-50",
      "overflow-hidden"
    ].compact.join(" ")
  end

  def card_classes_footer
    [
      "bg-orange-50",
      "p-4",
      "sm:p-6",
      # content? is not always working as described, and is returning a proc in some cases rather than a boolean
      ("rounded-t-none" if content.blank?)
    ].compact.join(" ")
  end
end
