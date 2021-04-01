# frozen_string_literal: true

FactoryBot.define do
  factory :commmit do
    name { Faker::Hipster.word }
    start_date { Date.today }
    length_in_days { 1 }

    trait :discarded do
      discarded_at { Time.now }
    end

    trait :finished do
      start_date { Date.yesterday }
      length_in_days { 1 }
    end

    factory :discarded_commmit, traits: [:discarded]
    factory :finished_commmit, traits: [:finished]
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
