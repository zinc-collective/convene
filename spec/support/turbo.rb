module Spec
  module Turbo
    def have_rendered_turbo_stream(action, target, content = nil, **rendering, &block)
      HaveRenderedTurboStream.new(action, target, content, view: view, **rendering, &block)
    end

    class HaveRenderedTurboStream
      include MiniTest::Assertions
      include ::Turbo::TestAssertions
      include Rails::Dom::Testing::Assertions
      include ::ActionDispatch::Assertions::ResponseAssertions
      attr_accessor :action, :target, :rendering, :view, :content, :callback, :failing_select, :response

      attr_writer :assertions

      def initialize(action, target, content = nil, view:, **rendering, &callback)
        self.action = action
        self.target = target
        self.content = content
        self.rendering = rendering
        self.view = view
        self.callback = callback
      end

      def matches?(response)
        @response = response
        assert_turbo_stream(action: action, target: target)
        if rendering.present?
          expected = Nokogiri.parse(strip_whitespace(view.render(**rendering))).canonicalize
          actual = Nokogiri.parse(strip_whitespace(css_select("*[target='#{dom_id(target)}'] template").inner_html)).canonicalize
          assert_dom_equal(expected, actual)
        end
      rescue Minitest::Assertion => e
        self.failing_select = e
        false
      end

      private def strip_whitespace(html)
        html.gsub(/$\s*/, "").gsub(/>\s+</, "><")
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
  config.include(ActionView::TestCase::Behavior, type: :request)
end
