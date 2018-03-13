class Campus < ApplicationRecord
  self.table_name = 'campuses' # Somehow rails cannot pluralize 'Campus' automatically
  
  validates :title, presence: true
  belongs_to :location
end
