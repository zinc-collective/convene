# Links Rooms to People for permissioning and similar purposes
class RoomOwnership < ApplicationRecord
  # Which Room the Person owns
  belongs_to :room

  # Which Person owns the Room
  belongs_to :owner, class_name: :Person
end