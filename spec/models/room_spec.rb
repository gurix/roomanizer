require 'rails_helper'

RSpec.describe Room do
  it { is_expected.to validate_presence_of(:title) }
  it { is_expected.to validate_presence_of(:floor_id) }
  it { is_expected.to belong_to(:floor) }
end
