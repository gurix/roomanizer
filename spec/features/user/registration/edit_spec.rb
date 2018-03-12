require 'rails_helper'

describe 'Editing account' do
  before do
    @user = create :user
    login_as(@user)
  end

  it 'edits the account' do
    visit edit_user_registration_path

    expect(page).to have_title 'Edit account - Base'
    expect(page).to have_active_navigation_items 'User menu', 'Edit account'
    expect(page).to have_breadcrumbs 'Base', 'User test name', 'Edit account'
    expect(page).to have_headline 'Edit account'

    fill_in 'user_name',  with: 'gustav'
    fill_in 'user_email', with: 'new-user@example.com'
    fill_in 'user_about', with: 'Some info about me'

    fill_in 'user_avatar', with: base64_other_image[:data]

    fill_in 'user_password',              with: 'n3wp4ssw0rd'
    fill_in 'user_password_confirmation', with: 'n3wp4ssw0rd'
    fill_in 'user_current_password',      with: 's3cur3p@ssw0rd'

    expect {
      click_button 'Save'
      @user.reload
    } .to  change { @user.name }.to('gustav')
      .and change { File.basename(@user.avatar.to_s) }.to('avatar.png')
      .and change { @user.about }.to('Some info about me')
      .and change { @user.encrypted_password }

    expect(page).to have_flash 'Your account has been updated successfully'
  end

  it "doesn't change the password if left empty" do
    visit edit_user_registration_path

    fill_in 'user_current_password', with: 's3cur3p@ssw0rd'

    expect {
      click_button 'Save'
    }.not_to change { @user.reload.encrypted_password }
  end

  describe 'avatar upload' do
    it 'caches an uploaded avatar during validation errors' do
      visit edit_user_registration_path

      # Upload a file
      fill_in 'user_avatar', with: base64_image[:data]

      # Trigger validation error
      click_button 'Save'
      expect(page).to have_flash('User could not be updated.').of_type :alert

      # Make validations pass
      fill_in 'user_current_password', with: 's3cur3p@ssw0rd'

      click_button 'Save'

      expect(page).to have_flash 'Your account has been updated successfully.'
      expect(File.basename(@user.reload.avatar.to_s)).to eq 'avatar.png'
    end

    it 'replaces a cached uploaded avatar with a new one after validation errors', js: true do
      visit edit_user_registration_path

      # Upload a file
      fill_in 'user_avatar', with: base64_image[:data]

      # Trigger validation error
      click_button 'Save'
      expect(page).to have_flash('User could not be updated.').of_type :alert

      # Upload another file
      scroll_by(0, 10000) # Otherwise the footer overlaps the element and results in a Capybara::Poltergeist::MouseEventFailed, see http://stackoverflow.com/questions/4424790/cucumber-capybara-scroll-to-bottom-of-page
      click_link 'Click to paste another Profile picture image'
      fill_in 'user_avatar',  with: base64_other_image[:data]

      # Make validations pass
      fill_in 'user_current_password', with: 's3cur3p@ssw0rd'

      click_button 'Save'

      expect(page).to have_flash 'Your account has been updated successfully.'
      expect(@user.reload.avatar.file.size).to eq base64_other_image[:size]
    end

    it 'allows to remove a cached uploaded avatar after validation errors' do
      visit edit_user_registration_path

      # Upload a file
      fill_in 'user_avatar', with: base64_image[:data]

      # Trigger validation error
      click_button 'Save'
      expect(page).to have_flash('User could not be updated.').of_type :alert

      # Remove avatar
      check 'user_remove_avatar'

      # Make validations pass
      fill_in 'user_current_password', with: 's3cur3p@ssw0rd'

      click_button 'Save'

      expect(page).to have_flash 'Your account has been updated successfully.'
      expect(@user.reload.avatar.to_s).to eq ''
    end

    it 'allows to remove an uploaded avatar' do
      @user.update_attributes! avatar: File.open(dummy_file_path('image.jpg'))

      visit edit_user_registration_path

      check 'user_remove_avatar'

      # Make validations pass
      fill_in 'user_current_password', with: 's3cur3p@ssw0rd'

      expect {
        click_button 'Save'
      }.to change { File.basename User.find(@user.id).avatar.to_s }.from('image.jpg').to eq '' # Here @user.reload works! Not the same as in https://github.com/carrierwaveuploader/carrierwave/issues/1752!

      expect(page).to have_flash 'Your account has been updated successfully.'
    end

    it 'does not display fields to update the password if the user signed up via exchange' do
      @user.update_attributes! from_exchange: true

      visit edit_user_registration_path

      expect(page).to_not have_content "New password (leave blank if you don't want to change it)"
    end
  end
end
