class DropJitsiMeetDomain < ActiveRecord::Migration[7.0]
  def change
    remove_column :spaces, :jitsi_meet_domain, :string
  end
end
