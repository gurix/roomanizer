require 'rails_helper'

describe User do
  it { is_expected.to strip_attribute(:name) }
  it { is_expected.to strip_attribute(:about) }

  it 'has a valid factory' do
    expect(create(:user)).to be_valid
  end

  it 'provides optimistic locking' do
    user = create :user
    stale_user = User.find(user.id)

    user.update_attribute :name, 'new-name'

    expect {
      stale_user.update_attribute :name, 'even-newer-name'
    }.to raise_error ActiveRecord::StaleObjectError
  end

  describe 'versioning', versioning: true do
    it 'is versioned' do
      is_expected.to be_versioned
    end

    describe 'attributes' do
      before { @user = create :user }
      it 'versions name' do
        expect {
          @user.update_attributes! name: 'daisy'
        }.to change { @user.versions.count }.by 1
      end

      it 'versions about (en/de)' do
        [:en, :de].each do |locale|
          expect {
            @user.update_attributes! "about_#{locale}" => 'I like make up'
          }.to change { @user.versions.count }.by 1
        end
      end

      it 'versions role' do
        expect {
          @user.update_attributes! role: 'admin'
        }.to change { @user.versions.count }.by 1
      end
    end
  end

  describe 'translating' do
    before { @user = create :user }

    it 'translates about' do
      expect {
        Mobility.with_locale(:de) { @user.update_attributes! about: 'Deutsches Über' }
        @user.reload
      }.not_to change { @user.about }
      expect(@user.about_de).to eq 'Deutsches Über'
    end
  end
end
