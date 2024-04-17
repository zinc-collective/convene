# frozen_string_literal: true

class BrandHeaderComponent < ApplicationComponent
  def initialize(space:)
    @space = space
  end

  def sections
    Pundit.policy_scope(current_person, @space.rooms)
  end

  def render?
    @space.present?
  end
end
