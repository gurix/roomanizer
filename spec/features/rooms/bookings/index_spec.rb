require 'rails_helper'

describe 'Listing bookings' do
  it 'lists bookings for a bookable resource' do
    user = create :user
    another_user = create :user, name: 'another user', email: 'another_user@exaple.com'
    room = create :room

    booking_1 = create :booking, bookable: room, organisator: user
    booking_2 = create :booking, bookable: room, organisator: another_user, start_at: Time.now + 3.hour, end_at: Time.now + 4.hour
    booking_3 = create :booking, bookable: room, organisator: another_user, start_at: Time.now + 5.hour, end_at: Time.now + 6.hour
    past_booking = create :booking, bookable: room, organisator: user, start_at: Time.now - 3.hour, end_at: Time.now - 2.hour

    login_as(user)

    visit polymorphic_path(room)

    expect(page).to have_css dom_id_selector(booking_1)
    expect(page).to have_css dom_id_selector(booking_2)
    expect(page).to have_css dom_id_selector(booking_3)
    expect(page).to_not have_css dom_id_selector(past_booking)
  end
end
