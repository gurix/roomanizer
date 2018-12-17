require 'rails_helper'

describe 'Showing the home page' do
  before { visit root_path }

  it 'displays a welcome message' do
    expect(page).to have_title 'Desksharing β'
    expect(page).to have_breadcrumbs 'Startpage'
    expect(page).to have_headline 'Desksharing β'
  end
end
