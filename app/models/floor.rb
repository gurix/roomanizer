class Floor < ApplicationRecord
  validates :title, presence: true
  belongs_to :building
end
