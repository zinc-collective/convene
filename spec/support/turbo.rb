module Spec
  module Turbo
    def have_rendered_turbo_stream(action, target, content = nil, **, &)
      HaveRenderedTurboStream.new(action, target, content, turbo_stream: controller.send(:turbo_stream), **, &)
    end

    class HaveRenderedTurboStream
      include Minitest::Assertions
      include ::Turbo::TestAssertions
      include Rails::Dom::Testing::Assertions
      include ::ActionDispatch::Assertions::ResponseAssertions
      attr_accessor :action, :target, :rendering, :turbo_stream, :content, :callback, :failing_select, :response

      attr_writer :assertions

      def initialize(action, target, content = nil, turbo_stream:, **rendering, &callback)
        self.action = action
        self.target = target
        self.content = content
        self.rendering = rendering
        self.turbo_stream = turbo_stream
        self.callback = callback
      end

      def matches?(response)
        @response = response
        assert_turbo_stream(action: action, target: target) do
          rendering[:allow_inferred_rendering] = false if action == :remove
          assert_dom_equal(turbo_stream.action(action, target, content, **rendering), response.body)
        end
      rescue Minitest::Assertion => e
        self.failing_select = e
        false
      end

      def assertions
        @assertions ||= 0
      end

      def description
        "render turbo stream action '#{action}' on target '#{dom_id(target)}' using #{rendering}"
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
