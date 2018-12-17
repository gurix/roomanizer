require 'rails_helper'

describe 'Showing room' do
  before do
    @user = create :user, :admin
    login_as(@user)
  end

  it 'displays a user' do
    room = create :room, :with_floor, title: 'Hell'

    visit room_path(room)

    expect(page).to have_title 'Hell - Desksharing'
    expect(page).to have_active_navigation_items 'Rooms'
    expect(page).to have_breadcrumbs 'Startpage', 'Rooms', 'Hell'
    expect(page).to have_headline 'Hell'

    within dom_id_selector(room) do
      expect(page).to have_css '.title',      text: 'Hell'
      expect(page).to have_css '.created_at', text: 'Mon, 15 Jun 2015 14:33:52 +0200'
      expect(page).to have_css '.updated_at', text: 'Mon, 15 Jun 2015 14:33:52 +0200'

      expect(page).to have_link 'Edit'
      expect(page).to have_link 'Delete'
    end
  end
end
