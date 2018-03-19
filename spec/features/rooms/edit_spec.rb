require 'rails_helper'

describe 'Editing room' do
  before do
    @room = create :room, :with_floor
    @user = create :user
  end

  context 'as a guest' do
    it 'does not grant permission to edit a room' do
      visit edit_room_path(@room)

      expect(page).to have_flash('You need to sign in or sign up before continuing.').of_type :alert
    end
  end

  context 'signed in as admin' do
    before do
      admin = create :user, :admin
      login_as(admin)
    end

    it "prevents from overwriting other rooms changes accidently (caused by race conditions)" do
      visit edit_room_path(@room)

      # Change something in the database...
      expect {
        @room.update_attributes! title: 'interim-title'
      }.to change { @room.lock_version }.by 1

      fill_in 'room_title', with: 'new-title'

      expect {
        click_button 'Update Room'
        @room.reload
      }.not_to change { @room }

      expect(page).to have_flash('Room meanwhile has been changed. The conflicting field is: Title.').of_type :alert

      within '#stale_attribute_room_title' do
        expect(page).to have_css '.attribute',        text: 'Title'
        expect(page).to have_css '.value_before',     text: 'interim-title'
        expect(page).to have_css '.value_after',      text: 'new-title'
        expect(page).to have_css '.value_difference', text: 'No diff view available (please activate JavaScript)'
      end

      expect {
        click_button 'Update Room'
        @room.reload
      } .to  change { @room.title }.to('new-title')
    end

    it "generates a diff view on displaying optimistic locking warning", js: true do
      visit edit_room_path(@room)

      # Change something in the database...
      expect {
        @room.update_attributes! title:  'Some title'
      }.to change { @room.lock_version }.by 1

      fill_in 'room_title', with: 'New Title'

      expect {
        click_button 'Update Room'
        @room.reload
      }.not_to change { @room }

      expect(page).to have_flash('Room meanwhile has been changed. The conflicting field is: Title.').of_type :alert

      expect(page.html).to include '<pre data-diff-result=""><del style="background:#ffe6e6;">Some t</del><ins style="background:#e6ffe6;">New T</ins><span>itle</span></pre>'
    end
  end
end
