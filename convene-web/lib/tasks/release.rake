namespace :release do
  desc "Ensures any post-release / pre-deploy behavior has occurred"
  task after_build: [:environment, "db:prepare"] do
    DemoSpace.prepare
    SystemTestSpace.prepare
  end
end
