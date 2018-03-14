require 'rails_helper'

RSpec.describe Building do
  it { is_expected.to validate_presence_of(:title) }
  it { is_expected.to validate_presence_of(:address) }
  it { is_expected.to belong_to(:campus) }
end
