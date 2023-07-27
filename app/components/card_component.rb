class CardComponent < ApplicationComponent
  renders_one :footer

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
      "bg-white"
    ].compact.join(" ")
  end

  def card_classes_footer
    [
      "bg-purple-50",
      "p-4",
      "sm:p-6",
      ("rounded-t-none" unless content.present?)
    ].compact.join(" ")
  end
end
