require 'rails_helper'

describe 'I18n' do
  it 'uses english as default locale' do
    visit root_path

    expect(page).to have_content 'Desksharing β'
  end

  it 'offers contents in english' do
    visit root_path(locale: :en)

    expect(page).to have_content 'Desksharing β'
  end

  it 'offers contents in german' do
    visit root_path(locale: :de)

    expect(page).to have_content 'Desksharing β'
  end

  it 'sets the html locale' do
    visit root_path

    expect(page).to have_css 'html[lang="en"]'
  end
end
