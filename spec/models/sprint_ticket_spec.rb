require 'rails_helper'

RSpec.describe SprintTicket, type: :model do
  context "determining closed_at" do
    describe "when closed_at is nil" do
      let(:sprint_ticket) { build(:sprint_ticket) }

      it "should return Unmerged" do
        expect(sprint_ticket.closed_at_formatted).to eq('Unmerged')
      end
    end

    describe "when closed_at is not nil" do
      let!(:time) { Time.now }
      let(:sprint_ticket) { build(:sprint_ticket, closed_at: time) }

      it "should return the correct value" do
        expect(sprint_ticket.closed_at_formatted).to eq(time.to_date.to_formatted_s(:long))
      end
    end
  end
end