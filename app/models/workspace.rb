class Workspace < ApplicationRecord
  validates :title, presence: true
  belongs_to :room
end
