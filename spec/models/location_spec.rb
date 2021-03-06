require 'rails_helper'

RSpec.describe Location do
  it { is_expected.to validate_presence_of(:title) }
  it { is_expected.to have_many(:campuses) }
end
