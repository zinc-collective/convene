module Spec
  module SystemHelpers
    def sign_in(user, space)
      visit(polymorphic_path(space.location))
      click_link_or_button("Sign in")
      fill_in("authenticated_session[contact_location]", with: user.email)
      find('input[type="submit"]').click
      perform_enqueued_jobs
      delivery = ActionMailer::Base.deliveries.first
      return sign_in(user, space) unless delivery
      visit(URI.parse(URI.extract(delivery.body.to_s)[1]).request_uri)
    end

    def dom_id(*args, **kwargs)
      ActionView::RecordIdentifier.dom_id(*args, **kwargs)
    end

    def t(*args, **kwargs)
      I18n.t(*args, **kwargs)
    end
  end
end

RSpec.configure do |config|
  config.include(ActiveJob::TestHelper, type: :system)
  config.include(Spec::SystemHelpers, type: :system)
end
