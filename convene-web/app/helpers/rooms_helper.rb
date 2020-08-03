module RoomsHelper
  def video_room_path(workspace, room)
    if workspace.branded_domain.present?
      "https://#{workspace.branded_domain}/#{room.slug}"
    else
      workspace_room_path(room.workspace, room)
    end
  end
end
