Rails.application.config.to_prepare do
  [Rails.root.join('app', 'furniture', '**', 'breadcrumbs.rb'),
   Rails.root.join('app', 'furniture', '**', 'breadcrumbs', '*.rb')].each do |crumb_path|
    Gretel.breadcrumb_paths << crumb_path
    Rails.autoloaders.main.ignore(crumb_path)
  end
end
