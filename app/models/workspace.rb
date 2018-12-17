class Workspace < ApplicationRecord
  include Bookable

  validates :title, :room, presence: true
  belongs_to :room

  has_many :images, as: :imageable, dependent: :destroy
  has_many :bookings, as: :bookable, dependent: :destroy
  accepts_nested_attributes_for 'images', allow_destroy: true, reject_if: -> attributes {
    # Ignore lock_version and _destroy when checking for attributes
    attributes.all? { |key, value| %w(_destroy lock_version).include?(key) || value.blank? }
  }

  def title
    return self[:title] if room.blank?
    "#{self[:title]} (#{room.title})"
  end
end
