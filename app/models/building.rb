class Building < ApplicationRecord
  validates :title, :address, presence: true
  belongs_to :campus
end
