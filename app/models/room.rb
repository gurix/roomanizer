class Room < ApplicationRecord
  validates :title, :floor_id, presence: true
  belongs_to :floor
end
