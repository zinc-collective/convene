# frozen_string_literal: true

FactoryBot.define do
  factory :embedded_form do
    transient do
      room { build(:room) }
    end

    placement do
      association :furniture_placement, {furniture_kind: "embedded_form", room: room}
    end
  end
end
