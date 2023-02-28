# frozen_string_literal: true

namespace :release do
  desc "Ensures any post-release / pre-deploy behavior has occurred"
  task after_build: [:environment, "db:prepare"] do
    SystemTestSpace.prepare
    Blueprint.prepare_clients!
  end
end
