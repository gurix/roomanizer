require 'rails_helper'

describe 'Creating room' do
  before do
    login_as create :user, :admin
    create :floor
  end

  it 'creates a room' do
    visit new_room_path

    expect(page).to have_title 'Create Room - Desksharing'
    expect(page).to have_active_navigation_items 'Rooms', 'Create Room'
    expect(page).to have_breadcrumbs 'Startpage', 'Rooms', 'Create'
    expect(page).to have_headline 'Create Room'

    expect(page).to have_css 'h2', text: 'Room information'

    fill_in 'room_title',  with: 'newtitle'
    
    select '10, Toniareal, Zentrum', from: 'room_floor_id'

    within '.actions' do
      expect(page).to have_css 'h2', text: 'Actions'

      expect(page).to have_button 'Create Room'
      expect(page).to have_link 'List of Rooms'
    end

    click_button 'Create Room'

    expect(page).to have_flash 'Room was successfully created.'
  end
end
