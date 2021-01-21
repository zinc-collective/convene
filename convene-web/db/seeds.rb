# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

zee = Person.find_or_create_by!(email: 'zee@example.com', name: 'Zee')
tom = Person.find_or_create_by!(email: 'tom@example.com', name: 'Tom')
bene = Person.find_or_create_by!(email: 'bene@example.com', name: 'Bene')

zinc = Client.find_or_create_by!(name: 'Zinc')

zincs_space = zinc.spaces
                      .find_or_create_by!(name: 'Zinc')
zincs_space.update!(access_level: :unlocked,
                        branded_domain: 'meet.zinc.local',
                        jitsi_meet_domain: 'convene-videobridge-zinc.zinc.coop')

zincs_space.members << zee
zincs_space.members << tom
zincs_space.members << bene

ada = zincs_space.rooms.find_or_initialize_by(name: 'Ada')
ada.update!(access_level: :unlocked, publicity_level: :listed)
ttz = zincs_space.rooms.find_or_initialize_by(name: 'Talk to Zee')
ttz.update!(access_level: :unlocked, publicity_level: :unlisted)
ttz.owners << zee

DemoSpace.prepare
SystemTestSpace.prepare
