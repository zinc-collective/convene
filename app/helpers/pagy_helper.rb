module PagyHelper
  include Pagy::Backend
  include Pagy::Frontend

  # @todo submit a patch to Pagy which allows us to override the classes using `nav_extra`
  #       since there wasn't a tidy seam to inject tailwind classes on the container beyond
  #       copy-paste-and-replace
  def pagy_nav(pagy, pagy_id: nil, link_extra: "", nav_extra: "", **vars)
    p_id = %( id="#{pagy_id}") if pagy_id
    link = pagy_link_proc(pagy, link_extra: link_extra)
    p_prev = pagy.prev
    p_next = pagy.next

    html = +%(<nav#{p_id} class="pagy-nav pagination #{nav_extra}">)
    html << if p_prev
      %(<span class="page prev">#{link.call p_prev, pagy_t("pagy.nav.prev"), 'aria-label="previous"'}</span> )
    else
      %(<span class="page prev disabled">#{pagy_t("pagy.nav.prev")}</span> )
    end
    pagy.series(**vars).each do |item| # series example: [1, :gap, 7, 8, "9", 10, 11, :gap, 36]
      html << case item
      when Integer then %(<span class="page">#{link.call item}</span> )
      when String then %(<span class="page active">#{pagy.label_for(item)}</span> )
      when :gap then %(<span class="page gap">#{pagy_t("pagy.nav.gap")}</span> )
      else raise InternalError, "expected item types in series to be Integer, String or :gap; got #{item.inspect}"
      end
    end
    html << if p_next
      %(<span class="page next">#{link.call p_next, pagy_t("pagy.nav.next"), 'aria-label="next"'}</span>)
    else
      %(<span class="page next disabled">#{pagy_t("pagy.nav.next")}</span>)
    end
    html << %(</nav>)
  end
end
