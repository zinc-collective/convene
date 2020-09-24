class WaitingRoom
  include ActiveModel::Model

  attr_accessor :room, :access_code

  def workspace
    room.workspace
  end

  def persisted?
    room.persisted?
  end

  def id
    room.id
  end

  def update(params)
    if params[:access_code] == room.access_code
      self.access_code = params[:access_code]
      true
    else
      errors.add(:access_code, :incorrect)
      false
    end
  end
end
