require "rails_helper"

RSpec.describe "rake release:after_build" do
  subject do
    ConveneWeb::Application.load_tasks
    Rake::Task["release:after_build"].reenable
    Rake::Task["release:after_build"].execute
  end

  it { is_expected.not_to raise_error }
end
