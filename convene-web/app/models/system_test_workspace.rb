class SystemTestWorkspace < WorkspaceSeed
  # Creates the system test workspace, but only on environments which are
  # configured to include the system test workspace.
  def self.prepare
    return unless Feature.enabled?(:system_test)
    super
  end

  class Factory
    private def client_name
      'Zinc'
    end

    private def workspace_config
      {
        name: 'System Test',
        jitsi_meet_domain: 'convene-videobridge-zinc.zinc.coop',
        branded_domain: "#{ENV.fetch('HEROKU_APP_NAME')}.herokuapp.com",
        access_level: :unlocked,
      }
    end

    private def rooms_config
      [
        {
          name: "Listed Room 1",
          publicity_level: :listed,
        },
        {
          name: "Listed Room 2",
          publicity_level: :listed,
        },
        {
          name: "Unlisted Room 1",
          publicity_level: :unlisted,
        },
        {
          name: "Unlisted Room 2",
          publicity_level: :unlisted,
        }
      ]
    end
  end
end
