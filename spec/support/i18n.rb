module Spec
  module Support
    module I18n
      def translate(lookup, *args, **kwargs)
        if lookup.starts_with?(".")
          # There's probably a less hacky way to do this, but for some reason the i18n key is '/' separated,
          # not '.' separated and lookup fails?
          path = ActiveModel::Name.new(described_class).i18n_key.to_s.tr("/", ".")
          ::I18n.t(path.concat(lookup), *args, **kwargs)
        else
          ::I18n.t(lookup, *args, **kwargs)
        end
      end
      alias_method :t, :translate
    end
  end
end

RSpec.configure do |config|
  config.include(Spec::Support::I18n, type: :mailer)
end
