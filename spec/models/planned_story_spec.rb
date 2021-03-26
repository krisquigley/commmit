# frozen_string_literal: true

require 'rails_helper'

RSpec.describe PlannedStory, type: :model do
  describe 'when a planned story is completed' do
    it 'should update the story it is attached to, as completed'
    context 'when it is repeatable' do
      it 'should not update the story it is attached to'
    end
  end
end
