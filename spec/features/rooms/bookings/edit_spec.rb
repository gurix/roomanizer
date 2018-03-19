require 'rails_helper'

describe 'Edit booking' do
  before do
    @organisator = create :user
    @booking = create :booking, organisator: @organisator, bookable: create(:room)
  end

  context 'signed in as an other user' do
    before { login_as(create :user, email: 'another_user@example.com', name:'another_user') }

    it 'does not grant permission to delete booking from others' do
      visit(polymorphic_path [:edit, @booking.bookable, @booking])

      expect(page).to have_flash('You are not authorized to access this page.').of_type :alert
    end
  end

  context 'signed in as organisator' do
    before { login_as(@organisator) }

    it 'can edit booking' do
      visit(polymorphic_path [:edit, @booking.bookable, @booking])

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

      click_button 'Update Booking'

      expect(page).to have_flash 'Booking was successfully updated.'
    end
  end
end
