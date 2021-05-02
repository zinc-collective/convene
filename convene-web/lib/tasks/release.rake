# frozen_string_literal: true

namespace :release do
  desc 'Ensures any post-release / pre-deploy behavior has occurred'
  task after_build: [:environment, 'db:prepare'] do
    Blueprint.prepare_clients!
    DemoSpace.prepare
    SystemTestSpace.prepare
  end
end
