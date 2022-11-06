class WaitingRoom
  include ActiveModel::Model

  attr_accessor :room, :access_code, :redirect_url

  delegate :space, to: :room

  delegate :persisted?, to: :room

  delegate :id, to: :room

  def update(params)
    if params[:access_code] == room.access_code
      self.access_code = params[:access_code]
      self.redirect_url = params[:redirect_url]
      true
    else
      errors.add(:access_code, :incorrect)
      false
    end
  end
end
