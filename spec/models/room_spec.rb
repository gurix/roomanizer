require 'rails_helper'

RSpec.describe Room do
  it { is_expected.to validate_presence_of(:title) }
  it { is_expected.to belong_to(:floor) }

  describe '#free?' do
    it 'recognize a room as free or occupied' do
      room = create :room, bookings:[
        Booking.new(start_at: Time.now - 4.hours, end_at: Time.now - 2.hours),
        Booking.new(start_at: Time.now - 1.hour, end_at: Time.now + 1.hour)
      ]

      expect(room.free?).to be false
      expect(room.free?(Time.now - 3.hours)).to be false
      expect(room.free?(Time.now + 3.hours)).to be true
    end
  end

  describe '#bookings_between' do
    it 'returns booking in a certain range of time' do
      room = create :room, bookings:[
        Booking.new(start_at: Time.now - 4.hours, end_at: Time.now - 2.hours),
        Booking.new(start_at: Time.now - 1.hour, end_at: Time.now + 1.hour)
      ]

      expect(room.bookings_between(Time.now - 6.hours, Time.now + 6.hours).count).to eq 2
      expect(room.bookings_between(Time.now - 6.hours, Time.now - 5.hours).count).to eq 0
      expect(room.bookings_between(Time.now - 6.hours, Time.now - 3.hours).count).to eq 1
      expect(room.bookings_between(Time.now - 3.hours, Time.now - 2.hours).count).to eq 1
    end
  end
end
