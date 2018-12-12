class User < ApplicationRecord
  validates :name, presence: true
  
  belongs_to :team
  has_many :tickets
end