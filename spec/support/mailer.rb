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
    end
  end
end
RSpec.configure do |config|
  config.include(Spec::Support::Mailer, type: :mailer)
end
