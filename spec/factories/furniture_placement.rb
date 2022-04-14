FactoryBot.define do
  factory :furniture_placement do
    room
    furniture_kind { "markdown_text_block" }
    settings { { content: "# Original Content"} }
    slot_position { :last }
  end
end
