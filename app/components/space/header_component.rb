# frozen_string_literal: true

class Space::HeaderComponent < ApplicationComponent
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
