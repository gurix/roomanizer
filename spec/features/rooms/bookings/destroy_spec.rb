require 'rails_helper'

describe 'Deleting booking' do
  before do
    @organisator = create :user
    @booking = create :booking, organisator: @organisator, bookable: create(:room)
  end

  context 'signed in as an other user' do
    before { login_as(create :user, email: 'another_user@example.com', name:'another_user') }

    it 'does not grant permission to delete booking from others' do
      visit_delete_path_for([@booking.bookable,@booking])

      expect(page).to have_flash('You are not authorized to access this page.').of_type :alert
    end
  end

  context 'signed in as organisator' do
    before { login_as(@organisator) }

    it 'grants permission to delete booking' do
      expect {
        visit_delete_path_for([@booking.bookable,@booking])
      }.to change { Booking.count }.by -1

      expect(page).to have_flash 'Booking was successfully destroyed.'
    end
  end
end
