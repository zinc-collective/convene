# frozen_string_literal: true

class Marketplace::Tag::DisplayComponent < ApplicationComponent
  with_collection_parameter :tag
  attr_accessor :tag
  delegate :label, to: :tag

  def initialize(tag:, data: {}, classes: "")
    super(data: data, classes: classes)

    self.tag = tag
  end
end
