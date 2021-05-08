# frozen_string_literal: true

# @see https://github.com/kzkn/gretel
crumb :root do
  if current_space.present?
    link current_space.name, space_path(current_space)
  else
    link t('home.title'), root_path
  end
end

crumb :edit_space do |space|
  link 'Configure', edit_space_path(space)
end

crumb :utility_hookups do |space|
  link 'Utility Hookups', space_utility_hookups_path(space)
  parent :edit_space, space
end

crumb :guides do
  link t('guides.title'), guides_path
end

crumb :guide do |guide|
  link t("guides.#{guide.slug}.title"), guide_path(guide)
  parent :guides
end

crumb :room do |room|
  link room.name, space_room_path(room.space, room)
end

crumb :edit_room do |room|
  link "Configure #{room.name}", edit_space_room_path(room.space, room)
  parent :room, room
end

crumb :waiting_room do |waiting_room|
  link 'Waiting Room', space_room_waiting_room_path(waiting_room.room.space, waiting_room.room)
  parent :room, waiting_room.room
end