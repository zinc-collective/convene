class Marketplace
  class MenuComponent < ApplicationComponent
    attr_accessor :marketplace, :cart

    def initialize(marketplace:, cart:, **kwargs)
      super(**kwargs)
      self.marketplace = marketplace
      self.cart = cart
    end

    def menu_tags_ordered
      @menu_tags_ordered ||= marketplace.tags.menu_tag.by_position
    end

    def products_for_menu_tag(tag)
      tag.products.with_all_rich_text.unarchived.sort_alpha
    end

    def all_other_products
      @all_other_products ||= marketplace.products.with_all_rich_text.unarchived.without_menu_tag.sort_alpha
    end
  end
end
