require "rails_helper"

RSpec.describe "rake release:after_build" do
  subject(:run_rake_task!) do
    ConveneWeb::Application.load_tasks
    Rake::Task["release:after_build"].reenable
    Rake::Task["release:after_build"].execute
  end

  it "does not fail" do
    expect { run_rake_task! }.not_to raise_error
  end
end
