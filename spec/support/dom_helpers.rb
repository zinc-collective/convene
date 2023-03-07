module DomHelpers
  def record_identifier
    ActionView::RecordIdentifier
  end
  delegate :dom_id, to: :record_identifier

  def test_response
    TestResponse.new(response)
  end

  class TestResponse < SimpleDelegator
    def media_type?(expected_media_type)
      media_type == Mime[expected_media_type]
    end
  end
end
