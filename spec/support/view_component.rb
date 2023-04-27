# spec/rails_helper.rb
require "view_component/test_helpers"
require "capybara/rspec"

module Spec
  module Support
    module ViewComponent
      delegate :polymorphic_path, to: :vc_test_controller
    end
  end
end

RSpec.configure do |config|
  config.include Spec::Support::ViewComponent, type: :component
  config.include ViewComponent::TestHelpers, type: :component
  config.include ViewComponent::SystemTestHelpers, type: :component
  config.include Capybara::RSpecMatchers, type: :component
end
