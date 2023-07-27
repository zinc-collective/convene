class CardComponent < ApplicationComponent
  renders_one :footer

  private

  def content_classes
    [
      "p-4",
      "sm:p-6"
    ].compact.join(" ")
  end

  def wrapper_classes
    [
      "shadow",
      "rounded-lg",
      "bg-white"
    ].compact.join(" ")
  end

  def footer_classes
    [
      "bg-purple-50",
      "p-4",
      "sm:p-6",
      ("rounded-t-none" if content?)
    ].compact.join(" ")
  end
end
