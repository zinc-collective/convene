FactoryBot.define do
  factory :markdown_text_block do
    transient do
      content { "# Original Content" }
    end

    room
    furniture_kind { "markdown_text_block" }
    settings { {content: content} }
    slot_position { :last }
  end
end
