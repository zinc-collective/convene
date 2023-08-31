require "rails_helper"

RSpec.describe PersonPolicy do
  describe "Scope" do
    subject(:scope) { described_class::Scope.new(person, Person) }

    let!(:person) { create(:person) }
    let!(:other_person) { create(:person) }

    it "includes themselves" do
      expect(scope.resolve).to include(person)
    end

    it "does not include anyone else" do
      expect(scope.resolve).not_to include(other_person)
    end

    context "when the person is an Operator" do
      let(:person) { create(:person, :operator) }

      it "includes all persons" do
        expect(scope.resolve).to match_array(Person.all)
      end
    end
  end
end
