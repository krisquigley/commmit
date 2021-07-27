# frozen_string_literal: true

require 'rails_helper'

RSpec.describe PlannedStory, type: :model do
  describe 'marking a planned story as done' do
    let(:story) { create(:story) }
    let(:commmit) { create(:commmit) }
    let(:planned_story) { create(:planned_story, story_id: story.id, commmit_id: commmit.id) }

    it 'should also mark the story as done' do
      completed_time = Time.current.to_s

      planned_story.update!(completed_at: completed_time)
      expect(story.reload.completed_at).to eq(completed_time)
    end
  end

  describe 'marking a planned story as not done' do
    let(:completed_time) { Time.current.to_s }
    let(:story) { create(:story, completed_at: completed_time) }
    let(:commmit) { create(:commmit) }
    let(:planned_story) do
      create(:planned_story, story_id: story.id,
                             commmit_id: commmit.id,
                             completed_at: completed_time)
    end

    it 'should also mark the story as not done' do
      planned_story.update!(completed_at: nil)
      expect(story.reload.completed_at).to eq(nil)
    end
  end

  describe 'repeatable stories' do
    context 'when there is only one planned story' do
      let(:completed_time) { Time.current.to_s }
      let(:repeatable_story) { create(:repeatable_story, completed_at: completed_time) }
      let(:commmit) { create(:commmit) }
      let(:planned_story) do
        create(:planned_story, story_id: repeatable_story.id,
                               commmit_id: commmit.id,
                               completed_at: completed_time)
      end

      it 'should set the story back to incomplete when marked as not done' do
        planned_story.update!(completed_at: nil)
        expect(repeatable_story.reload.completed_at).to eq(nil)
      end
    end

    context 'when there is more than one planned story' do
      let(:prev_completed_time) { (Time.current - 1.day).to_s }
      let(:new_completed_time) { Time.current.to_s }
      let(:repeatable_story) { create(:repeatable_story, completed_at: new_completed_time) }
      let(:commmit) { create(:commmit) }
      let!(:new_planned_story) do
        create(:planned_story, story_id: repeatable_story.id,
                               commmit_id: commmit.id,
                               completed_at: new_completed_time)
      end

      it 'should set the story back to the previous completed_at time when marked as not done' do
        create(:planned_story, story_id: repeatable_story.id, commmit_id: commmit.id, completed_at: prev_completed_time)

        expect(repeatable_story.completed_at).to eq(new_completed_time)
        new_planned_story.update!(completed_at: nil)
        expect(repeatable_story.reload.completed_at).to eq(prev_completed_time)
      end
    end
  end
end
