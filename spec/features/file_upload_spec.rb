require 'rails_helper'

describe 'Image paste upload' do
  it 'allows to paste a file' do
    @user = create :user, :with_avatar
    login_as(@user)

    visit edit_user_registration_path

    find('#user_avatar', visible: false).set base64_image[:data]
    fill_in 'user_current_password', with: 's3cur3p@ssw0rd'

    expect {
      click_button 'Save'
    }.to change { File.basename(@user.reload.avatar.to_s) }.from('image.jpg').to 'avatar.png'
  end

  it 'displays a preview of an uploaded image' do
    @user = create :user, :with_avatar
    login_as(@user)

    visit edit_user_registration_path

    expect(page).to have_css '.user_avatar .thumbnail img[src$="/image.jpg"]'
  end

  it 'displays a preview of an uploaded image (from the temporary cache) after a re-display of the form' do
    @user = create :user, :with_avatar
    login_as(@user)

    visit edit_user_registration_path

    find('#user_avatar', visible: false).set base64_other_image[:data]
    fill_in 'user_current_password', with: '' # Empty password triggers validation error and form re-display

    click_button 'Save'

    expect(page).to have_css '.user_avatar .thumbnail img[src^="/uploads/tmp/"]'
  end

  it 'uses an uploaded image (from the temporary cache) after a re-display and then successful submit of the form' do
    @user = create :user, :with_avatar
    login_as(@user)

    visit edit_user_registration_path

    find('#user_avatar', visible: false).set base64_other_image[:data]

    fill_in 'user_current_password', with: '' # Empty password triggers validation error and form re-display
    click_button 'Save'
    expect(page).to have_css '.user_avatar .thumbnail img[src^="/uploads/tmp/"]'

    fill_in 'user_current_password', with: 's3cur3p@ssw0rd'

    expect {
      click_button 'Save'
    }.to change { File.basename(@user.reload.avatar.to_s) }.from('image.jpg').to 'avatar.png'
  end

  it 'allows to remove a file' do
    @user = create :user, :with_avatar
    login_as(@user)

    visit edit_user_registration_path
    expect(page).to have_css 'img.avatar'

    check 'user_remove_avatar'

    fill_in 'user_current_password', with: 's3cur3p@ssw0rd'

    click_button 'Save'

    # Notice: it would be nice to check upon change of @user.avatar or something like that, but didn't succeed with this...
    expect(page).not_to have_css 'img.avatar'
  end
end
