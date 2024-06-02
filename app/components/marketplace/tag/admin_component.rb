# frozen_string_literal: true

class Marketplace::Tag::AdminComponent < ApplicationComponent
  with_collection_parameter :tag
  attr_accessor :tag
  delegate :label, to: :tag

  def initialize(tag:, data: {}, classes: "")
    super(data: data, classes: classes)

    self.tag = tag
  end

  def edit_button?
    tag.persisted? && policy(tag).edit?
  end

  def destroy_button?
    tag.persisted? && policy(tag).destroy?
  end

  def assigned_product_count
    # Consider optimizing this query with a counter cache or other method
    # if it becomes a performance bottleneck.
    @assigned_product_count ||= tag.product_tags.count
  end
end
