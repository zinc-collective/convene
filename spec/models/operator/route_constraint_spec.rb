require "rails_helper"

RSpec.describe Operator::RouteConstraint do
  subject(:route_constraint) { described_class.new }

  before do
    allow(Person).to receive(:find_by).with(id: "operator-1234").and_return(instance_double(Operator, operator?: true))
    allow(Person).to receive(:find_by).with(id: "neighbor-1234").and_return(instance_double(Person, operator?: false))
  end

  it { is_expected.not_to be_matches(instance_double(Rack::Request, session: {})) }
  it { is_expected.to be_matches(instance_double(Rack::Request, session: {person_id: "operator-1234"})) }
  it { is_expected.not_to be_matches(instance_double(Rack::Request, session: {person_id: "neighbor-1234"})) }
end
