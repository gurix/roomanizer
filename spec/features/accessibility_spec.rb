require 'rails_helper'

describe 'Accessibility' do
  describe 'required form fields' do
    it 'displays a visually hidden text "(required)" at the end of the label' do
      visit new_user_registration_path

      expect(page).to have_css 'label[for="user_name"]', text: 'Name (required)'
      expect(page).to have_css 'label[for="user_name"] .sr-only', text: '(required)'
    end
  end

  describe 'form validations' do
    it 'assigns the help blocks with the inputs through aria-describedby', js: true do
      visit new_user_registration_path
      click_button 'Sign up'

      expect(page).to have_css 'input#user_name[aria-describedby="user_name_help"]'
      expect(page).to have_css '#user_name_help'
    end

    it 'sets the focus to the first invalid element', js: true do
      visit new_user_registration_path
      fill_in 'user_name', with: 'daisy' # Make sure the first occurring element is valid, so explicitly the second one (email) should gain focus
      click_button 'Sign up'

      # Check for focused element, see http://stackoverflow.com/questions/7940525/testing-focus-with-capybara
      expect(page.evaluate_script('document.activeElement.id')).to eq 'user_email'
    end
  end

  describe 'page title' do
    it "displays the app name suffix on every page except the home page" do
      visit root_path
      expect(page).to have_title 'Welcome to Base!'

      visit page_path('about')
      expect(page).to have_title 'About Base - Base'
    end

    it 'prepends flash messages' do
      visit new_user_registration_path
      click_button 'Sign up'
      expect(page).to have_title 'Alert: User could not be created. Sign up - Base'
    end
  end
end
