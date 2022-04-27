# frozen_string_literal: true

# A Space that's accessible at both a branded domain and `/spaces/system-test/`:
#  - http://system-test.zinc.local
#  - http://localhost:3000/spaces/system-test/
# @deprecated use blueprints instead when possible
class SystemTestSpace
  # Creates the system test space on environments that include it by default,
  # such as review apps, test, and local dev environments.
  def self.prepare
    return unless Feature.enabled?(:system_test)

    Space.find_by(name: 'System Test')&.destroy

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

  DEFAULT_SPACE_CONFIG = Blueprint::BLUEPRINTS[:system_test]
end
