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

crumb :show_space_agreement do |agreement|
  parent :root, agreement.space
  link t("show.link_to", name: agreement.name)
end

crumb :new_space_agreement do |agreement|
  parent :edit_space, agreement.space
  link t("space.agreements.new.link_to")
end

crumb :edit_space_agreement do |agreement|
  parent :edit_space, agreement.space
  link t("space.agreements.edit.link_to", name: agreement.name)
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

crumb :utilities do |space|
  link "Utilities", space.location(child: :utilities)
  parent :edit_space, space
end

crumb :new_utility do |utility|
  link t("utilities.new.link_to"), utility.location
  parent :edit_space, utility.space
end

crumb :edit_utility do |utility|
  link t("utilities.edit.link_to", name: utility.name, utility_type: utility.utility_slug)
  parent :edit_space, utility.space
end

crumb :room do |room|
  link room.name, [room.space, room] unless room.entrance?
end

crumb :new_room do |room|
  link t("helpers.submit.room.create"), [:new, room.space, :room]
  parent :edit_space, room.space
end

crumb :edit_room do |room|
  link t("helpers.submit.room.edit", room_name: room.name), [:edit, room.space, room]
  parent :room, room
end

crumb :rsvp do |rsvp|
  link "Respond to your Invitation"
  parent :root, rsvp.space
end

crumb :edit_furniture do |furniture|
  link "Configure #{furniture.title}"
  parent :edit_room, furniture.room
end
