# @see https://thoughtbot.com/blog/building-custom-rspec-matchers-with-regular-objects
module Spec
  module Support
    module Mailer
      def be_to(email_addresses)
        BeToMatcher.new(email_addresses)
      end

      def have_subject(subject)
        HaveSubjectMatcher.new(subject)
      end

      def render_component(component)
        RenderComponentMatcher.new(component)
      end

      class BeToMatcher
        attr_accessor :to, :email_addresses
        def initialize(email_addresses)
          self.email_addresses = email_addresses
        end

        def matches?(mail)
          self.to = mail.to
          to == email_addresses
        end

        def failure_message
          "Expected mail to be to '#{email_addresses}', was '#{to}'"
        end

        def description
          "be to '#{to}'"
        end
      end

      class HaveSubjectMatcher
        attr_accessor :expected_subject, :actual_subject

        def initialize(expected_subject)
          self.expected_subject = expected_subject
        end

        def matches?(mail)
          self.actual_subject = mail.subject
          actual_subject == expected_subject
        end

        def failure_message
          "Expected mail subject to be '#{expected_subject}', was '#{actual_subject}'"
        end

        def description
          "have subject '#{expected_subject}'"
        end
      end

      class RenderComponentMatcher
        include Minitest::Assertions
        include Rails::Dom::Testing::Assertions
        attr_accessor :expected_component, :mail, :args, :kwargs, :failing_select

        attr_writer :assertions

        def initialize(expected_component)
          @expected_component = expected_component
        end

        def matches?(mail)
          self.mail = mail
          assert_select("##{initialized_component.dom_id}") do
            children.each do |(selector, content)|
              assert_select(selector, content)
            end
          end
        rescue Minitest::Assertion => e
          self.failing_select = e
          false
        end

        def initialized_with(*args, **kwargs)
          self.args = args
          self.kwargs = kwargs
          self
        end

        def initialized_component
          @initialized_component ||= expected_component.new(*args, **kwargs)
        end

        def assertions
          @assertions ||= 0
        end

        def description
          description = "render component #{expected_component}"
          if args || kwargs
            description << " initialized with"
            description << " arguments #{args}" if args.present?
            description << " and" if args.present? && kwargs.present?
            description << " keyword arguments #{kwargs}" if kwargs.present?
          end

          description
        end

        def failure_message
          failing_select.message
        end

        def containing(selector, content)
          children << [selector, content]
          self
        end

        def children
          @children ||= []
        end

        private def document_root_element
          @document_root_element ||= Nokogiri::HTML::Document.parse(mail.body.encoded)
        end
      end
    end
  end
end
RSpec.configure do |config|
  config.include(Spec::Support::Mailer, type: :mailer)
end
