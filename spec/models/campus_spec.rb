require 'rails_helper'

RSpec.describe Campus do
  it { is_expected.to validate_presence_of(:title) }
  it { is_expected.to belong_to(:location) }
  it { is_expected.to have_many(:buildings) }
end
