class Booking < ApplicationRecord
  belongs_to :bookable, polymorphic: true
  belongs_to :organisator, class_name: 'User'

  has_and_belongs_to_many :users

  validates :start_at, :end_at, presence: true
  validates_datetime :end_at, after: :start_at
  validate :availability

  def availability
    conflicting_bookings = self.class.where('(start_at BETWEEN ? AND ?) OR (end_at BETWEEN ? AND ?)', start_at, end_at, start_at, end_at)
    conflicting_bookings.where(bookable: bookable)
    errors.add(:bookable, :not_available) if conflicting_bookings.count > 0
  end
end
