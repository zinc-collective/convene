# frozen_string_literal: true

class Space::HeaderComponent < ApplicationComponent
  def initialize(space:)
    @space = space
  end

  def sections
    policy_scope(@space.rooms)
  end

  def header_txt_color
    @header_txt_color ||= @space.header_txt_color || "black"
  end

  def header_bg_color
    @header_bg_color ||= @space.header_bg_color || "white"
  end

  def render?
    @space.present? && @space.entrance.present?
  end
end
