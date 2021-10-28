# frozen_string_literal: true

# Walkthroughs and other sorts of things for using Convene
class Guide
  include ActiveModel::Model
  attr_accessor :slug, :value_proposition
  alias id slug

  def to_partial_path
    slug.to_s
  end

  def attributes
    { id: id, slug: slug }
  end

  def persisted?
    true
  end

  # TODO: There is probably a way to get an "ActiveRecord::Query"-like
  # interface without writing it ourselves.
  def self.all
    %i[neighborhoods people spaces rooms furniture getting_around identification].lazy.map do |slug|
      new(slug: slug)
    end
  end

  def self.find_by!(**attributes)
    found = all.find do |item|
      item.attributes.values_at(*attributes.keys) == attributes.values
    end

    return found if found

    raise ActiveRecord::RecordNotFound.new("No feature with #{attributes}", Feature)
  end
end
