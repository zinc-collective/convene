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

Blueprint.new(client: {
  name: "Zinc",
  space: {
    members: [zee, tom, bene],
    name: "Zinc", branded_domain: 'meet.zinc.local',
    access_level: :unlocked,
    jitsi_meet_domain: 'convene-videobridge-zinc.zinc.coop',
    rooms: [{
      name: "Ada",
      access_level: :unlocked,
      publicity_level: :listed,
      furniture_placements: {
        videobridge_jitsi: {}
      }
    },
    {
      name: "Talk to Zee",
      access_level: :unlocked,
      publicity_level: :unlisted,
      furniture_placements: {
        videobridge_jitsi: {}
      }
    }]
  }
}).find_or_create!

DemoSpace.prepare
SystemTestSpace.prepare
