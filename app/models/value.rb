# frozen_string_literal: true

class Value < ApplicationRecord
  include Discard::Model
  
  before_validation :set_color, only: :create
  acts_as_tenant :account

  validates :name, presence: true, uniqueness: { scope: :account, case_sensitive: false }
  validates :color, presence: true

  has_and_belongs_to_many :commmits
  has_and_belongs_to_many :stories

  private

  def set_color
    self.color ||= ['#e6194b',
                    '#3cb44b',
                    '#ffe119',
                    '#4363d8',
                    '#f58231',
                    '#911eb4',
                    '#46f0f0',
                    '#f032e6',
                    '#bcf60c',
                    '#fabebe',
                    '#008080',
                    '#e6beff',
                    '#9a6324',
                    '#fffac8',
                    '#800000',
                    '#aaffc3',
                    '#808000',
                    '#ffd8b1',
                    '#000075',
                    '#808080'].sample
  end
end
