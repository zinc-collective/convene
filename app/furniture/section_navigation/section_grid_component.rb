class SectionNavigation
  class SectionGridComponent < ApplicationComponent
    delegate :policy_scope, to: :helpers

    def initialize(section_navigation)
      @section_navigation = section_navigation
    end

    def render?
      rooms.any?
    end

    private

    def description_height
      @description_height ||= section_descriptions? ? "min-h-[120px]" : ""
    end

    def image_placeholder?(room)
      section_images? && !room.hero_image?
    end

    BG_COLORS = %w[
      bg-cyan-100 bg-emerald-100 bg-indigo-100 bg-lime-100 bg-purple-100 bg-red-100
      bg-rose-100 bg-sky-100 bg-teal-100
    ].freeze
    def image_placeholder_div
      content_tag(:div, "", class: "h-36 #{BG_COLORS.sample} m-0 p-0 rounded-t-lg w-full")
    end

    def rooms
      @rooms = policy_scope(@section_navigation.rooms)
    end

    def section_images?
      @section_images ||= rooms.any?(&:hero_image?)
    end

    def section_descriptions?
      @section_descriptions ||= rooms.any? { |r| r.description.present? }
    end
  end
end
