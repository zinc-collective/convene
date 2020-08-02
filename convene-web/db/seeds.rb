# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

zee = Person.create(email: 'zee@example.com', name: "Zee")
tom = Person.create(email: 'tom@example.com', name: "Tom")
bene = Person.create(email: 'bene@example.com', name: "Bene")

zinc = Client.find_or_create_by(name: 'Zinc')

zincs_workspace = zinc.workspaces
                      .find_or_create_by(name: 'Zinc',
                                         access_level: :unlocked,
                                         jitsi_meet_domain: 'meet.zinc.coop')

zincs_workspace.members << zee
zincs_workspace.members << tom
zincs_workspace.members << bene


ada = zincs_workspace.rooms.create(name: 'Ada', access_level: :unlocked, publicity_level: :listed)
ttz = zincs_workspace.rooms.create(name: 'Talk to Zee', access_level: :unlocked, publicity_level: :unlisted)
ttz.owners << zee

DemoWorkspace.prepare