RSpec.shared_examples 'a space-member only route' do
  context 'As a Guest' do
    let(:actor) { guest }

    it 'is a noop 404' do
      if changes
        expect { perform_request }.not_to(change { changes.call })
      else
        perform_request
      end
      expect(response).to be_not_found
    end
  end

  context 'As a Neighbor' do
    let(:actor) { neighbor }
    it 'is a no-op 404' do
      if changes
        expect { perform_request }.not_to(change { changes.call })
      else
        perform_request
      end
      expect(response).to be_not_found
    end
  end

  context 'As a Space Member' do
    let(:actor) { space_member }
    it 'performs the action' do
      expect { perform_request }.to(change { changes.call }) if changes
      expect(response).not_to be_not_found
    end
  end
end
