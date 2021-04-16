# frozen_string_literal: true

class RenameRetroFeedbackToRetrospectives < ActiveRecord::Migration[5.2]
  def self.up
    rename_table :retro_feedback, :retrospectives
  end

  def self.down
    rename_table :retrospectives, :retro_feedback
  end
end
