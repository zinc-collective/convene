Rails.application.config.to_prepare do
  Gretel.breadcrumb_paths << Rails.root.join('app', 'furniture', '**', 'breadcrumbs.rb')
  Gretel.breadcrumb_paths << Rails.root.join('app', 'furniture', '**', 'breadcrumbs', '*.rb')
end
