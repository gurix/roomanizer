class Floor < ApplicationRecord
  validates :title, presence: true
  belongs_to :building

  def full_name
    "#{title}, #{building.title}, #{building.campus.title}, #{building.campus.location.title}"
  end
end
