class User < ApplicationRecord
  validates :name, :github_user_id, presence: true
  
  belongs_to :team, optional: true
  has_and_belongs_to_many :tickets
end