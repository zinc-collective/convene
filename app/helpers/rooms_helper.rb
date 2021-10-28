module RoomsHelper
  def end_call_path(space)
    if space.branded_domain.present?
      "https://#{space.branded_domain}/"
    else
      space_path(space)
    end
  end
end
