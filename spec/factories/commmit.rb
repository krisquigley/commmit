# frozen_string_literal: true

FactoryBot.define do
  factory :commmit do
    end_date { Time.current.to_date }
    goal_id { FactoryBot.create(:story).id }
    name { Faker::Fantasy::Tolkien.poem }

    trait :discarded do
      discarded_at { Time.now }
    end

    trait :finished do
      end_date { Time.current.to_date.yesterday }
    end

    factory :discarded_commmit, traits: [:discarded]
    factory :finished_commmit, traits: [:finished]
  end
end

def commmit_with_a_commmit_goal(stories_count: 5)
  commmit_goal = FactoryBot.create(:story)

  FactoryBot.create(:commmit, goal_id: commmit_goal.id, name: nil) do |commmit|
    FactoryBot.create_list(:story, stories_count) do |story|
      story.save
      FactoryBot.create(:planned_story, commmit: commmit, story: story)
    end
  end
end

def commmit_with_planned_stories(stories_count: 5)
  FactoryBot.create(:commmit) do |commmit|
    FactoryBot.create_list(:story, stories_count) do |story|
      story.save
      FactoryBot.create(:planned_story, commmit: commmit, story: story)
    end
  end
end

def commmit_with_completed_planned_stories(stories_count: 5)
  FactoryBot.create(:commmit) do |commmit|
    FactoryBot.create_list(:story, stories_count) do |story|
      story.save
      FactoryBot.create(:completed_planned_story, commmit: commmit, story: story)
    end
  end
end

def commmit_with_repeatable_planned_stories(stories_count: 5)
  FactoryBot.create(:commmit) do |commmit|
    FactoryBot.create_list(:repeatable_story, stories_count) do |story|
      story.save
      FactoryBot.create(:planned_story, commmit: commmit, story: story)
    end
  end
end

def finished_commmit_with_planned_stories(stories_count: 5)
  FactoryBot.create(:finished_commmit) do |commmit|
    FactoryBot.create_list(:story, stories_count) do |story|
      story.save
      FactoryBot.create(:planned_story, commmit: commmit, story: story)
    end
  end
end

def finished_commmit_with_completed_planned_stories(stories_count: 5)
  FactoryBot.create(:finished_commmit) do |commmit|
    FactoryBot.create_list(:completed_story, stories_count) do |story|
      story.save
      FactoryBot.create(:completed_planned_story, commmit: commmit, story: story)
    end
  end
end

def finished_commmit_with_completed_commmit_goal(stories_count: 5)
  commmit_goal = FactoryBot.create(:completed_story)

  finished_commmit = FactoryBot.create(:finished_commmit, goal_id: commmit_goal.id, name: nil) do |commmit|
    FactoryBot.create_list(:completed_story, stories_count) do |story|
      story.save
      FactoryBot.create(:completed_planned_story, commmit: commmit, story: story)
    end
  end

  finished_commmit.reload.commmit_goal.update(completed_at: Time.zone.now)

  finished_commmit
end

def finished_commmit_with_incomplete_commmit_goal(stories_count: 5)
  commmit_goal = FactoryBot.create(:story)

  FactoryBot.create(:finished_commmit, goal_id: commmit_goal.id, name: nil) do |commmit|
    FactoryBot.create_list(:completed_story, stories_count) do |story|
      story.save
      FactoryBot.create(:completed_planned_story, commmit: commmit, story: story)
    end
  end
end

def finished_commmit_with_completed_planned_stories_and_reflection(stories_count: 5)
  FactoryBot.create(:finished_commmit) do |commmit|
    FactoryBot.create_list(:completed_story, stories_count) do |story|
      story.save
      FactoryBot.create(:completed_planned_story, commmit: commmit, story: story)
    end

    FactoryBot.create(:completed_reflection, commmit: commmit)
  end
end
