require 'rails_helper'

describe 'Signing up' do
  it 'signs up a new user and lets him confirm his email' do
    visit new_user_registration_path

    expect(page).to have_title 'Sign up - Base'
    expect(page).to have_active_navigation_items 'Sign up'
    expect(page).to have_breadcrumbs 'Base', 'Sign up'
    expect(page).to have_headline 'Sign up'

    expect(page).to have_css 'legend h2', text: 'Account information'

    fill_in 'user_name', with: 'newuser'
    expect(page).not_to have_css '#user_role'
    fill_in 'user_email', with: 'newuser@example.com'
    fill_in 'user_avatar', with: base64_image[:data]
    fill_in 'user_about',                 with: 'Some info about me'

    expect(page).to have_css 'legend h2', text: 'Choose a password'

    fill_in 'user_password',              with: 'somegreatpassword'
    fill_in 'user_password_confirmation', with: 'somegreatpassword'

    expect(page).to have_css 'legend h2', text: 'Security question (CAPTCHA)'
    fill_in 'user_humanizer_answer', with: '5'

    within '.frequently_occuring_sign_in_problems' do
      expect(page).to have_css 'h2', text: 'Frequently occurring sign in problems'

      expect(page).to have_link 'Forgot your password?'
      # expect(page).to have_link "Didn't receive confirmation instructions?"
      expect(page).to have_link "Didn't receive unlock instructions?"
    end

    click_button 'Sign up'

    expect(page).to have_flash 'Welcome! You have signed up successfully.'

    expect(page).to have_link 'Log out'

    #visit_in_email('Confirm my account', 'newuser@example.com')
    #expect(page).to have_flash 'Your email address has been successfully confirmed.'
  end

  describe 'avatar upload' do
    it 'caches an uploaded avatar during validation errors' do
      visit new_user_registration_path

      # Upload a file
      fill_in 'user_avatar', with: base64_image[:data]

      # Trigger validation error
      click_button 'Sign up'
      expect(page).to have_flash('User could not be created.').of_type :alert

      # Make validations pass
      fill_in 'user_name',                  with: 'newuser'
      fill_in 'user_email',                 with: 'newuser@example.com'
      fill_in 'user_password',              with: 'somegreatpassword'
      fill_in 'user_password_confirmation', with: 'somegreatpassword'
      fill_in 'user_humanizer_answer',      with: '5'

      click_button 'Sign up'

      expect(page).to have_flash 'Welcome! You have signed up successfully.'
      expect(File.basename(User.last.avatar.to_s)).to eq 'avatar.png'
    end

    it 'replaces a cached uploaded avatar with a new one after validation errors', js: true do
      visit new_user_registration_path

      # Upload a file
      fill_in 'user_avatar', with: base64_image[:data]

      # Trigger validation error
      click_button 'Sign up'
      expect(page).to have_flash('User could not be created.').of_type :alert

      # Upload another file
      scroll_by(0, 10000) # Otherwise the footer overlaps the element and results in a Capybara::Poltergeist::MouseEventFailed, see http://stackoverflow.com/questions/4424790/cucumber-capybara-scroll-to-bottom-of-page
      click_link 'Click to paste another Profile picture image'
      fill_in 'user_avatar',  with: base64_other_image[:data]

      # Make validations pass
      fill_in 'user_name',                  with: 'newuser'
      fill_in 'user_email',                 with: 'newuser@example.com'
      fill_in 'user_password',              with: 'somegreatpassword'
      fill_in 'user_password_confirmation', with: 'somegreatpassword'
      fill_in 'user_humanizer_answer',      with: '5'

      click_button 'Sign up'

      expect(page).to have_flash 'Welcome! You have signed up successfully.'
      expect(File.basename(User.last.avatar.to_s)).to eq 'avatar.png'
    end

    it 'allows to remove a cached uploaded avatar after validation errors' do
      visit new_user_registration_path

      # Upload a file
      fill_in 'user_avatar', with: base64_image[:data]

      # Trigger validation error
      click_button 'Sign up'
      expect(page).to have_flash('User could not be created.').of_type :alert

      # Remove avatar
      check 'user_remove_avatar'

      # Make validations pass
      fill_in 'user_name',                  with: 'newuser'
      fill_in 'user_email',                 with: 'newuser@example.com'
      fill_in 'user_password',              with: 'somegreatpassword'
      fill_in 'user_password_confirmation', with: 'somegreatpassword'
      fill_in 'user_humanizer_answer',      with: '5'

      click_button 'Sign up'

      expect(page).to have_flash 'Welcome! You have signed up successfully.'
      expect(User.last.avatar.to_s).to eq ''
    end
  end

  it 'prevents from signing up on wrong CAPTCHA' do
    visit new_user_registration_path

    fill_in 'user_humanizer_answer', with: '123'
    click_button 'Sign up'

    within '.user_humanizer_answer.has-error' do
      expect(page).to have_content "You're not a human"
    end

    fill_in 'user_humanizer_answer', with: '5'
    click_button 'Sign up'

    expect(page).not_to have_css '.user_humanizer_answer.has-error'
  end
end
