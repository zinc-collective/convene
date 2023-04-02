module Spec
  module Turbo
    def have_rendered_turbo_stream(action, target, partial: nil)
      HaveRenderedTurboStream.new(action, target, partial: partial)
    end

    class HaveRenderedTurboStream
      include MiniTest::Assertions
      include ::Turbo::TestAssertions
      include Rails::Dom::Testing::Assertions
      include ::ActionDispatch::Assertions::ResponseAssertions
      attr_accessor :action, :target, :partial, :failing_select, :response

      attr_writer :assertions

      def initialize(action, target, partial: nil)
        self.action = action
        self.target = target
        self.partial = partial
      end

      def matches?(response)
        @response = response
        assert_turbo_stream(action: action, target: target)
      rescue Minitest::Assertion => e
        self.failing_select = e
        false
      end

      def assertions
        @assertions ||= 0
      end

      def description
        "render turbo stream action '#{action}' on target '#{dom_id(target)}'"
      end

      def failure_message
        failing_select.message
      end

      private def document_root_element
        @document_root_element ||= Nokogiri::HTML::Document.parse(response.body)
      end
    end
  end
end

RSpec.configure do |config|
  config.include(Spec::Turbo, type: :request)
end
