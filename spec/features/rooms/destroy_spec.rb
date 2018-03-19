require 'rails_helper'

describe 'Deleting room' do
  before { @room = create :room, :with_floor }

  context 'signed in as user' do
    before { login_as(create :user) }

    it 'does not grant permission to delete own room' do
      visit_delete_path_for(@room)

      expect(page).to have_flash('You are not authorized to access this page.').of_type :alert
    end
  end

  context 'signed in as admin' do
    before do
      admin = create :user, :admin
      login_as(admin)
    end

    it 'grants permission to delete other room' do
      expect {
        visit_delete_path_for(@room)
      }.to change { Room.count }.by -1

      expect(page).to have_flash 'Room was successfully destroyed.'
    end
  end
end
