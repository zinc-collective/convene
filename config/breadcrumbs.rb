# frozen_string_literal: true

# @see https://github.com/kzkn/gretel
crumb :root do
  if current_space.present?
    link current_space.name, current_space
  else
    link t("home.title"), root_path
  end
end

crumb :edit_space do |space|
  link "Configure Space", [:edit, space]
end

crumb :memberships do |space|
  link "Members", [space, :memberships]
  if policy(space).edit?
    parent :edit_space, space
  else
    parent :root
  end
end

crumb :show_membership do |membership|
  link membership.member_name, [membership.space, membership]
  parent :memberships, membership.space
end

crumb :invitations do |space|
  link "Invitations", [space, :invitations]
  parent :memberships, space
end

crumb :utility_hookups do |space|
  link "Utility Hookups", [space, :utility_hookups]
  parent :edit_space, space
end

crumb :new_utility_hookup do |utility_hookup|
  link "New Utility Hookup", [:new, utility_hookup.space, :utility_hookup]
  parent :utility_hookups, utility_hookup.space
end

crumb :room do |room|
  link room.name, [room.space, room] unless room.entrance?
end

crumb :new_room do |room|
  link t("helpers.submit.room.create"), [:new, room.space, :room]
  parent :edit_space, room.space
end

crumb :edit_room do |room|
  link t("helpers.submit.room.edit", {room_name: room.name}), [:edit, room.space, room]
  parent :room, room
end

crumb :waiting_room do |waiting_room|
  link "Waiting Room", space_room_waiting_room_path(waiting_room.room.space, waiting_room.room)
  parent :room, waiting_room.room
end

crumb :rsvp do |rsvp|
  link "Respond to your Invitation"
  parent :root, rsvp.space
end

crumb :edit_furniture_placement do |furniture_placement|
  link "Configure #{furniture_placement.title}"
  parent :edit_room, furniture_placement.room
end
