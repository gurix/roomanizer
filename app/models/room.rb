class Room < ApplicationRecord
  include Bookable

  belongs_to :floor
  has_many :bookings, as: :bookable
  has_many :workspaces
  has_many :images, as: :imageable, dependent: :destroy

  accepts_nested_attributes_for 'images', allow_destroy: true, reject_if: -> attributes {
    # Ignore lock_version and _destroy when checking for attributes
    attributes.all? { |key, value| %w(_destroy lock_version).include?(key) || value.blank? }
  }

  validates :title, presence: true
end
