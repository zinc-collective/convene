class Journal
  class KeywordsController < FurnitureController
    expose(:keyword, scope: -> { policy_scope(journal.keywords) }, model: Keyword,
      find: ->(id, scope) { scope.find_by(canonical_keyword: id) })

    expose(:journal, -> { Journal.find(params[:journal_id]) })
    def show
      authorize(keyword)
    end
  end
end
