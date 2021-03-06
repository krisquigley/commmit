# frozen_string_literal: true

class Ticket < ApplicationRecord
  acts_as_tenant(:account)

  validates :title, :estimated_effort, :issue_id, :repository_name, :number, :state, presence: true
  validates :issue_id, uniqueness: true

  scope :filter_by_repository_name, ->(repository_name) { where(repository_name: repository_name) }
  scope :search_by_title_or_issue_number, lambda { |keywords|
    where('lower(title) || number LIKE ?', "%#{keywords.downcase}%")
  }
  scope :search_by_title_or_issue_number_and_filter, lambda { |keywords, repository_name|
    where('lower(title) || number LIKE ? AND repository_name = ?', "%#{keywords.downcase}%",
          repository_name)
  }
end
