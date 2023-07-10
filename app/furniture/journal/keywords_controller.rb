class Journal
  class KeywordsController < Controller
    expose(:keyword, scope: -> { policy_scope(journal.keywords) })
    def show
      authorize(keyword)
    end
  end
end
