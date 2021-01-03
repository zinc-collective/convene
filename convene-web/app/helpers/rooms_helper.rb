module RoomsHelper
  def end_call_path(workspace)
    if workspace.branded_domain.present?
      "https://#{workspace.branded_domain}/"
    else
      workspace_path(workspace)
    end
  end
end
