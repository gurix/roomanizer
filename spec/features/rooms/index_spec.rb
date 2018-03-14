require 'rails_helper'

describe 'Listing rooms' do
  before do
    @room = create :room, :with_floor
    @admin = create :user, :admin

    login_as(@admin)
  end

  it 'displays rooms' do
    visit rooms_path

    expect(page).to have_title 'Rooms - Desksharing'
    expect(page).to have_active_navigation_items 'Rooms', 'List of Rooms'
    expect(page).to have_breadcrumbs 'Desksharing', 'Rooms'
    expect(page).to have_headline 'Rooms'

    expect(page).to have_css 'h2', text: 'Filter'
    expect(page).to have_css 'h2', text: 'Results'

    within dom_id_selector(@room) do
      expect(page).to have_css '.title a', text: '10.T.35'

      expect(page).to have_link 'Edit'
      expect(page).to have_link 'Delete'
    end

    within 'div.actions' do
      expect(page).to have_css 'h2', text: 'Actions'
      expect(page).to have_link 'Create Room'
    end
  end

  it 'allows to filter rooms' do
    @room_1 = create :room, :with_floor, title: 'anne'
    @room_2 = create :room, :with_floor, title: 'marianne'
    @room_3 = create :room, :with_floor, title: 'eva'

    visit rooms_path

    expect(page).to have_css dom_id_selector(@room_1)
    expect(page).to have_css dom_id_selector(@room_2)
    expect(page).to have_css dom_id_selector(@room_3)

    fill_in 'q_title_cont', with: 'anne'
    click_button 'Filter'

    expect(page).to     have_css dom_id_selector(@room_1)
    expect(page).to     have_css dom_id_selector(@room_2)
    expect(page).not_to have_css dom_id_selector(@room_3)

    click_link 'Remove filter'

    expect(page).to have_css dom_id_selector(@room_1)
    expect(page).to have_css dom_id_selector(@room_2)
    expect(page).to have_css dom_id_selector(@room_3)
  end
end
