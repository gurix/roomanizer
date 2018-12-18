class Building < ApplicationRecord
  validates :title, :address, presence: true
  belongs_to :campus
  has_many :floors
end
