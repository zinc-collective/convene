class Neighborhood::LinkComponent < ApplicationComponent
  include ViewComponent::InlineTemplate

  erb_template <<~ERB
    <%= link_to name, url %>: <%= tagline %>
  ERB

  def neighborhood
    @neighborhood ||= Neighborhood.new
  end

  delegate :name, :url, :tagline, to: :neighborhood
end
