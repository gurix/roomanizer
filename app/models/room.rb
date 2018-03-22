class Room < ApplicationRecord
  belongs_to :floor
  has_many :bookings, as: :bookable
  has_many :workspaces
  has_many :images, as: :imageable, dependent: :destroy

  accepts_nested_attributes_for 'images', allow_destroy: true, reject_if: -> attributes {
    # Ignore lock_version and _destroy when checking for attributes
    attributes.all? { |key, value| %w(_destroy lock_version).include?(key) || value.blank? }
  }

  validates :title, presence: true

  def actual_booking(at = Time.now)
    bookings.where('start_at <= ? AND end_at >=?', at, at)
  end

  def free?(at = Time.now)
    actual_booking(at).count == 0
  end

  def bookings_between(start_at, end_at)
    bookings.where('(start_at BETWEEN ? AND ?) OR (end_at BETWEEN ? AND ?)', start_at, end_at, start_at, end_at)
  end

  def next_bookings(at = Time.now)
    bookings.where('end_at >= ?', at).order(start_at: :asc)
  end
end
