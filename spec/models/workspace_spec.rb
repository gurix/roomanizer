require 'rails_helper'

RSpec.describe Workspace do
  it { is_expected.to validate_presence_of(:title) }
  it { is_expected.to belong_to(:room) }
end
