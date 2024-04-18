# frozen_string_literal: true

class BrandHeaderComponent < ApplicationComponent
  def initialize(space:)
    @space = space
  end

  def sections
    policy_scope(@space.rooms)
  end

  def render?
    @space.present?
  end
end
