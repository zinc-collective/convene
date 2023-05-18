class CardComponent < ApplicationComponent
  renders_one :footer

  private

  def card_classes
    [
      "shadow",
      "rounded-lg",
      "bg-white",
      "p-4",
      "sm:p-6",
      ("rounded-b-none" if footer?)
    ].compact.join(" ")
  end
end
