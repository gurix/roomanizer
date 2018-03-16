class Booking < ApplicationRecord
  belongs_to :bookable, polymorphic: true
  belongs_to :organisator, class_name: 'User'

  has_and_belongs_to_many :users

  validates :start_at, :end_at, presence: true
  validates_datetime :end_at, after: :start_at
  validate :availability_start
  validate :availability_end
  validate :availability_within

  # Checks whether there is a start from another booking in between
  def availability_start
    conflicting_bookings = other_bookings.where('start_at BETWEEN ? AND ?', start_at, end_at)
    errors.add(:start_at, I18n.t('activerecord.errors.models.booking.attributes.start_at.not_available',
      time: I18n.l(conflicting_bookings.first.start_at))) if conflicting_bookings.count > 0
  end

  # Checks whether there is an end from another booking in between
  def availability_end
    # Query for bookings ending in the requestet time period
    conflicting_bookings = other_bookings.where('end_at BETWEEN ? AND ?', start_at, end_at)
    errors.add(:end_at, I18n.t('activerecord.errors.models.booking.attributes.end_at.not_available',
      time: I18n.l(conflicting_bookings.first.end_at))) if conflicting_bookings.count > 0
  end

  # Checks whether there is a start and an end from another booking in between
  def availability_within
    # Query for bookings ending in the requestet time period
    conflicting_bookings = other_bookings.where('start_at <= ? AND end_at >= ?', start_at, end_at)
    if conflicting_bookings.count > 0
      errors.add(:start_at, I18n.t('activerecord.errors.models.booking.attributes.start_at.not_available',
        time: I18n.l(conflicting_bookings.first.start_at)))
      errors.add(:end_at, I18n.t('activerecord.errors.models.booking.attributes.end_at.not_available',
        time: I18n.l(conflicting_bookings.first.end_at)))
    end
  end

  # Filter for all bookings for a given resource not beeing itself
  def other_bookings
    self.class.where(bookable: bookable).where.not(id: id)
  end
end
