class Journal
  class KeywordsController < FurnitureController
    expose(:keyword, scope: -> { policy_scope(journal.keywords) }, model: Keyword,
      find: lambda do |id, scope|
        scope.search(id)&.first ||
          (raise ActiveRecord::RecordNotFound.new(nil, self, id, id))
      end)

    expose(:journal, -> { Journal.find(params[:journal_id]) })
    def show
      authorize(keyword)
    end
  end
end
