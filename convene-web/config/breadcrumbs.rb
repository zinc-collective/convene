# @see https://github.com/kzkn/gretel
crumb :root do
  if current_space.present?
    link current_space.name, space_path(current_space)
  else
    link t('home.title'), root_path
  end
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