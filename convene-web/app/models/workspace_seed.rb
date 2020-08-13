class WorkspaceSeed
  def self.prepare
    Factory.new(Client).find_or_create_workspace!
  end

  # Assembles the child WorkspaceSeed class using the provided Client and Workspace configs
  # classes.
  class Factory
    attr_accessor :client_repository

    # @param [ActiveRecord::Relation<Client>] client_repository Where to ensure there
    #  is a Zinc Client with the Convene Demo workspace
    def initialize(client_repository)
      self.client_repository = client_repository
    end

    # Creates the Workspace Seed and Client if necessary
    def find_or_create_workspace!
      workspace = client.workspaces.find_or_create_by!(name: workspace_config[:name])
      workspace.update!(jitsi_meet_domain: workspace_config[:jitsi_meet_domain],
                        branded_domain: workspace_config[:branded_domain],
                        access_level: workspace_config[:access_level])
      add_demo_rooms(workspace)
      workspace
    end

    private def add_demo_rooms(workspace)
      rooms_config.each do |room|
        workspace.rooms.find_or_create_by!(name: room[:name], publicity_level: room[:publicity_level])
      end
      workspace
    end

    private def client
      @_client ||= client_repository.find_or_create_by!(name: client_name)
    end

    private def client_name
      raise NotImplementedError
    end

    private def workspace_config
      raise NotImplementedError
    end

    private def rooms_config
      raise NotImplementedError
    end
  end
end
