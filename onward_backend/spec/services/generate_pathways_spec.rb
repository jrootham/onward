require 'rails_helper'

module Services
  RSpec.describe GeneratePathways, type: :helper do
    let(:query) { { hs_courses: ['ENG4U', 'SPH4U'] } }

    describe '#call' do
      it 'should return pathway results' do
        service = GeneratePathways.new(query)
        result = service.call
        expect(result[:pathways]).to_not be_nil
      end
    end
  end
end
