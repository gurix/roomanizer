require 'rails_helper'

describe 'Canceling account', pending: 'disabled at the moment' do
  before do
    @user = create :user
    login_as(@user)
  end

  it 'cancels the account' do
    visit root_path

    click_link 'Edit account'
    click_button 'Cancel my account'

    expect(page).to have_content 'Bye! Your account has been successfully cancelled. We hope to see you again soon.'
  end
end
