require 'rails_helper'

describe 'Create booking' do
  before do
    login_as create :user
    @room = create :room, title: '72.22.2'
  end

  it 'creates a booking for a room' do
    visit new_room_booking_path(@room)

    expect(page).to have_title 'Create Booking - Desksharing'
    expect(page).to have_active_navigation_items 'Rooms'
    expect(page).to have_breadcrumbs 'Startpage', 'Rooms', '72.22.2', 'Booking', 'Create'
    expect(page).to have_headline 'Create Booking'

    expect(page).to have_css 'h2', text: 'Booking information'

    select '2018', from: 'booking_start_at_1i'
    select 'April', from: 'booking_start_at_2i'
    select '27', from: 'booking_start_at_3i'
    select '16', from: 'booking_start_at_4i'
    select '20', from: 'booking_start_at_5i'

    select '2018', from: 'booking_end_at_1i'
    select 'April', from: 'booking_end_at_2i'
    select '27', from: 'booking_end_at_3i'
    select '20', from: 'booking_end_at_4i'
    select '50', from: 'booking_end_at_5i'

    within '.actions' do
      expect(page).to have_css 'h2', text: 'Actions'

      expect(page).to have_button 'Create Booking'
    end

    click_button 'Create Booking'

    expect(page).to have_flash 'Booking was successfully created.'
  end
end
