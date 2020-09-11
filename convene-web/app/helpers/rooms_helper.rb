module RoomsHelper
  def end_call_path(workspace)
    if workspace.branded_domain.present?
      "https://#{workspace.branded_domain}/"
    else
      workspace_path(workspace)
    end
  end

  def video_room_name(workspace, room)
    "#{workspace.slug}--#{room.slug}"
  end
end
