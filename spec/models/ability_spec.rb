# The ability is built upon the "everything disallowed first" principle:
# Nothing is allowed if not explicitly allowed somewhere. This means we have to test every explicit rule.

require 'rails_helper'

describe Ability do
  context 'when is a guest' do
    subject { Ability.new nil }

    describe 'managing codes' do
      it { should_not be_able_to(:index, Code) }
    end

    describe 'managing images' do
      it { should_not be_able_to(:index, Image) }
    end

    describe 'managing pages' do
      it { should_not be_able_to(:index, Page) }

      it { should_not be_able_to(:create, Page) }

      it { should     be_able_to(:read, Page.new) }

      it { should_not be_able_to(:update, Page.new) }

      it { should_not be_able_to(:destroy, Page.new) }
    end

    describe 'managing users' do
      it { should_not be_able_to(:index, User) }

      it { should     be_able_to(:create, User) }

      it { should_not be_able_to(:read, User.new) }

      it { should_not be_able_to(:update, User.new) }

      it { should_not be_able_to(:destroy, User.new) }

      it { should_not be_able_to(:edit_role, User.new) }
      it { should_not be_able_to(:edit_role, @user) }
    end

    describe 'managing versions' do
      it { should_not be_able_to(:index, PaperTrail::Version) }
    end

    describe 'managing rooms' do
      it { should_not be_able_to(:index, Room) }

      it { should_not be_able_to(:create, Room) }

      it { should_not be_able_to(:read, Room.new) }

      it { should_not be_able_to(:update, Room.new) }

      it { should_not be_able_to(:destroy, Room.new) }
    end

    describe 'managing workspaces' do
      it { should_not be_able_to(:index, Workspace) }

      it { should_not be_able_to(:create, Workspace) }

      it { should_not be_able_to(:read, Workspace.new) }

      it { should_not be_able_to(:update, Workspace.new) }

      it { should_not be_able_to(:destroy, Workspace.new) }
    end
  end

  context 'when is a user' do
    before  { @user = create(:user) }
    subject { Ability.new(@user) }

    describe 'managing codes' do
      it { should_not be_able_to(:index, Code) }
    end

    describe 'managing images' do
      it { should_not be_able_to(:index, Image) }
    end

    describe 'managing pages' do
      it { should_not be_able_to(:index, Page) }

      it { should_not be_able_to(:create, Page) }

      it { should     be_able_to(:read, Page.new) }

      it { should_not be_able_to(:update, Page.new) }

      it { should_not be_able_to(:destroy, Page.new) }
    end

    describe 'managing users' do
      it { should     be_able_to(:index, User) }

      it { should_not be_able_to(:create, User) }

      it { should     be_able_to(:read, User.new) }

      it { should_not be_able_to(:update, User.new) }
      it { should     be_able_to(:update, @user) }

      it { should_not be_able_to(:destroy, User.new) }

      it { should_not be_able_to(:edit_role, User.new) }
      it { should_not be_able_to(:edit_role, @user) }
    end

    describe 'managing versions' do
      it { should_not be_able_to(:index, PaperTrail::Version) }
    end

    describe 'managing rooms' do
      it { should_not be_able_to(:index, Room) }

      it { should_not be_able_to(:create, Room) }

      it { should     be_able_to(:read, Room.new) }

      it { should_not be_able_to(:update, Room.new) }

      it { should_not be_able_to(:destroy, Room.new) }
    end

    describe 'managing workspaces' do
      it { should_not be_able_to(:index, Workspace) }

      it { should_not be_able_to(:create, Workspace) }

      it { should     be_able_to(:read, Workspace.new) }

      it { should_not be_able_to(:update, Workspace.new) }

      it { should_not be_able_to(:destroy, Workspace.new) }
    end
  end

  context 'when is an editor' do
    before  { @user = create(:user, :editor) }
    subject { Ability.new(@user) }

    describe 'managing codes' do
      it { should be_able_to(:index, Code) }
    end

    describe 'managing images' do
      it { should be_able_to(:index, Image) }
    end

    describe 'managing pages' do
      it { should be_able_to(:index, Page) }

      it { should be_able_to(:create, Page) }

      it { should be_able_to(:read, Page.new) }

      it { should be_able_to(:update, Page.new) }

      it { should be_able_to(:destroy, Page.new) }
    end

    describe 'managing users' do
      it { should     be_able_to(:index, User) }

      it { should_not be_able_to(:create, User) }

      it { should     be_able_to(:read, User.new) }

      it { should_not be_able_to(:update, User.new) }
      it { should     be_able_to(:update, @user) }

      it { should_not be_able_to(:destroy, User.new) }
      it { should     be_able_to(:destroy, @user) }

      it { should_not be_able_to(:edit_role, User.new) }
      it { should_not be_able_to(:edit_role, @user) }
    end

    describe 'managing versions' do
      it { should be_able_to(:index, PaperTrail::Version) }
    end

    describe 'managing rooms' do
      it { should be_able_to(:index, Room) }

      it { should be_able_to(:create, Room) }

      it { should be_able_to(:read, Room.new) }

      it { should be_able_to(:update, Room.new) }

      it { should be_able_to(:destroy, Room.new) }
    end

    describe 'managing workspaces' do
      it { should be_able_to(:index, Workspace) }

      it { should be_able_to(:create, Workspace) }

      it { should be_able_to(:read, Workspace.new) }

      it { should be_able_to(:update, Workspace.new) }

      it { should be_able_to(:destroy, Workspace.new) }
    end
  end

  context 'when is an admin' do
    before  { @user = create :user, :admin }
    subject { Ability.new(@user) }

    describe 'managing codes' do
      it { should be_able_to(:index, Code) }
    end

    describe 'managing images' do
      it { should be_able_to(:index, Image) }
    end

    describe 'managing pages' do
      it { should be_able_to(:index, Page) }

      it { should be_able_to(:create, Page) }

      it { should be_able_to(:read, Page.new) }

      it { should be_able_to(:update, Page.new) }

      it { should be_able_to(:destroy, Page.new) }
    end

    describe 'managing users' do
      it { should     be_able_to(:index, User) }

      it { should     be_able_to(:create, User) }

      it { should     be_able_to(:read, User.new) }

      it { should     be_able_to(:update, User.new) }

      it { should     be_able_to(:destroy, User.new) }
      it { should_not be_able_to(:destroy, @user) }

      it { should_not be_able_to(:edit_role, @user) }
      it { should     be_able_to(:edit_role, User.new) }
    end

    describe 'managing versions' do
      it { should be_able_to(:index, PaperTrail::Version) }
    end

    describe 'managing rooms' do
      it { should be_able_to(:index, Room) }

      it { should be_able_to(:create, Room) }

      it { should be_able_to(:read, Room.new) }

      it { should be_able_to(:update, Room.new) }

      it { should be_able_to(:destroy, Room.new) }
    end

    describe 'managing workspaces' do
      it { should be_able_to(:index, Workspace) }

      it { should be_able_to(:create, Workspace) }

      it { should be_able_to(:read, Workspace.new) }

      it { should be_able_to(:update, Workspace.new) }

      it { should be_able_to(:destroy, Workspace.new) }
    end
  end
end
