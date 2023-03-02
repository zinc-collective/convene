# frozen_string_literal: true

class FurnitureController < ::ApplicationController
  include Room::ControllerMixins

  helper_method def space
    current_space
  end

  delegate :dom_id, to: :record_identifier

  def record_identifier
    @record_identifier ||= ActionView::RecordIdentifier
  end
end
