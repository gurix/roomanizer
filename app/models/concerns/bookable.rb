module Bookable
  include ActiveSupport::Concern

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

  def free_from(at = Time.now)
    actual_booking(at).order(end_at: :desc).first&.end_at
  end

  def free_until(at = Time.now)
    bookings.where('start_at > ?', at).order(start_at: :asc).first&.start_at
  end
end
