class SystemTestSpace
  # Creates the system test space, but only on environments which are
  # configured to include the system test space.
  def self.prepare
    return unless Feature.enabled?(:system_test)

    Blueprint.new(client: { name: 'System Test',
                            space: DEFAULT_SPACE_CONFIG.merge(
                              name: 'System Test Branded Domain',
                              branded_domain: 'system-test.zinc.local'
                            ) }).find_or_create!

    Blueprint.new(client: { name: 'System Test',
                            space: DEFAULT_SPACE_CONFIG
                              .merge(name: 'System Test') })
             .find_or_create!
  end

  DEFAULT_SPACE_CONFIG = {
    jitsi_meet_domain: 'convene-videobridge-zinc.zinc.coop',
    entrance: 'entrance-hall',
    access_level: :unlocked,
    rooms: [
      {
        name: 'Listed Room 1',
        publicity_level: :listed,
        access_level: :unlocked,
        access_code: nil,
        furniture_placements: {
          markdown_text_block: { content: '# Welcome!' },
          videobridge_by_jitsi: {},
          breakout_tables_by_jitsi: { names: %w[engineering design ops] }
        }
      },
      {
        name: 'Listed Room 2',
        publicity_level: :listed,
        access_level: :unlocked,
        access_code: nil,
        furniture_placements: {
          videobridge_by_jitsi: {}
        }
      },
      {
        name: 'Listed Locked Room 1',
        publicity_level: :listed,
        access_level: :locked,
        access_code: :secret,
        furniture_placements: {
          videobridge_by_jitsi: {}
        }
      },
      {
        name: 'Unlisted Room 1',
        publicity_level: :unlisted,
        access_level: :unlocked,
        access_code: nil,
        furniture_placements: {
          videobridge_by_jitsi: {}
        }
      },
      {
        name: 'Unlisted Room 2',
        publicity_level: :unlisted,
        access_level: :unlocked,
        access_code: nil,
        furniture_placements: {
          videobridge_by_jitsi: {}
        }
      },
      {
        name: 'Entrance Hall',
        publicity_level: :unlisted,
        furniture_placements: {
          markdown_text_block: { content: '# Wooo!' }
        }

      }
    ]
  }.freeze
end
