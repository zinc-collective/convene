# @see https://github.com/kzkn/gretel
crumb :root do
  if current_workspace.present?
    link current_workspace.name, workspace_path(current_workspace)
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