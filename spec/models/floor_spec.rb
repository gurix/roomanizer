require 'rails_helper'

RSpec.describe Floor do
  it { is_expected.to validate_presence_of(:title) }
  it { is_expected.to belong_to(:building) }
  it { is_expected.to have_many(:rooms) }
end
