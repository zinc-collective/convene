namespace :release do
  desc "Ensures any post-release / pre-deploy behavior has occurred"
  task after_build: [:environment, "db:prepare"] do
    DemoSpace.prepare
    SystemTestSpace.prepare

    # Create a FurniturePlacement in Slot 1 for the Jitsi Videobridge!
    Room.all.each do |room|
      room.furniture_placements.find_or_create_by!(name: 'videobridge_by_jitsi', slot: 0)
    end

    # Renames our furniture placements from tables to breakout_tables_by_jitsi
    FurniturePlacement.all.where(name: 'tables').update_all(name: 'breakout_tables_by_jitsi')
  end
end
