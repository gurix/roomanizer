require 'rails_helper'

describe 'Editing user' do
  before { @user = create :user, about: 'Info about me.' }

  context 'as a guest' do
    it 'does not grant permission to edit a user' do
      visit edit_user_path(@user)

      expect(page).to have_flash('You need to sign in or sign up before continuing.').of_type :alert
    end
  end

  context 'signed in as user' do
    before { login_as(@user) }

    it "doesn't allow to change role (even if hacker tries it)", js: true do
      visit edit_user_path(@user)

      expect {
        remove_html_attribute('#user_role', 'disabled') # A hacker could manually enable the option!
      }.to change { page.has_css?('#user_role[disabled]') }.to false

      select 'Administrator', from: 'user_role'

      expect {
        click_button 'Update User'
        @user.reload
      } .not_to change { @user.role }

      expect(page).to have_flash 'User was successfully updated.'
    end

    it 'grants permission to edit own user' do
      visit edit_user_path(@user)

      expect(page).to have_status_code 200
    end
  end

  context 'signed in as admin' do
    before do
      admin = create :user, :admin
      login_as(admin)
    end

    it 'grants permission to edit other user' do
      visit edit_user_path(@user)

      expect(page).to have_title 'Edit User test name - Desksharing'
      expect(page).to have_active_navigation_items 'Users'
      expect(page).to have_breadcrumbs 'Startpage', 'Users', 'User test name', 'Edit'
      expect(page).to have_headline 'Edit User test name'

      expect(page).to have_css 'h2', text: 'Account information'

      fill_in 'user_name',  with: 'gustav'
      fill_in 'user_email', with: 'new-gustav@example.com'
      fill_in 'user_about', with: 'Some info about me'
      select  'Editor', from: 'user_role'

      fill_in 'user_avatar', with: base64_other_image[:data]

      within '.actions' do
        expect(page).to have_css 'h2', text: 'Actions'

        expect(page).to have_button 'Update User'
        expect(page).to have_link 'List of Users'
      end

      expect {
        click_button 'Update User'
        @user.reload
      } .to  change { @user.name }.to('gustav')
        .and change { File.basename(@user.avatar.to_s) }.to('avatar.png')
        .and change { @user.about }.to('Some info about me')
        .and change { @user.role }.to ('editor')

      expect(page).to have_flash 'User was successfully updated.'
    end

    it "prevents from overwriting other users' changes accidently (caused by race conditions)" do
      visit edit_user_path(@user)

      # Change something in the database...
      expect {
        @user.update_attributes! name:   'interim-name',
                                 about:  "This is some barely interesting info.\n\nI like playing football and reading books.\n\nI don't work as a web developer anymore.",
                                 avatar: File.open(dummy_file_path('image.jpg'))
      }.to change { @user.lock_version }.by 1

      fill_in 'user_name',   with: 'new-name'
      fill_in 'user_avatar', with: base64_other_image[:data]

      expect {
        click_button 'Update User'
        @user.reload
      }.not_to change { @user }

      expect(page).to have_flash('User meanwhile has been changed. The conflicting fields are: Name, Profile picture, and About.').of_type :alert

      within '#stale_attribute_user_name' do
        expect(page).to have_css '.attribute',        text: 'Name'
        expect(page).to have_css '.value_before',     text: 'interim-name'
        expect(page).to have_css '.value_after',      text: 'new-name'
        expect(page).to have_css '.value_difference', text: 'No diff view available (please activate JavaScript)'
      end

      within '#stale_attribute_user_about_en' do
        expect(page).to have_css '.value_before',     text: 'This is some barely interesting info. I like playing football and reading books. I don\'t work as a web developer anymore.'
        expect(page).to have_css '.value_after',      text: 'Info about me.'
        expect(page).to have_css '.value_difference', text: 'No diff view available (please activate JavaScript)'
      end

      within '#stale_attribute_user_avatar' do
        expect(page).to have_css '.value_before img[alt="Image before"]'
        expect(page).to have_css '.value_after img[alt="Image after"]'
        expect(page).to have_css '.value_difference', text: 'Diff view not possible'
      end

      expect {
        click_button 'Update User'
        @user.reload
      } .to  change { @user.name }.to('new-name')
        .and change { @user.about }.to('Info about me.')
        .and change { File.basename(@user.avatar.to_s) }.to('avatar.png')
    end

    it "generates a diff view on displaying optimistic locking warning", js: true do
      visit edit_user_path(@user)

      # Change something in the database...
      expect {
        @user.update_attributes! about:  "This is some barely interesting info.\n\nI like playing football and reading books.\n\nI don't work as a web developer anymore."
      }.to change { @user.lock_version }.by 1

      fill_in 'user_about', with: "Yeah this looks different now!\n\nThis is some very interesting info.\n\nI like playing american football and watching movies."

      expect {
        click_button 'Update User'
        @user.reload
      }.not_to change { @user }

      expect(page).to have_flash('User meanwhile has been changed. The conflicting field is: About.').of_type :alert

      expect(page.html).to include '<pre data-diff-result=""><ins style="background:#e6ffe6;">Yeah this looks different now!¶<br>¶<br></ins><span>This is some </span><del style="background:#ffe6e6;">barel</del><ins style="background:#e6ffe6;">ver</ins><span>y interesting info.¶<br>¶<br>I like playing </span><ins style="background:#e6ffe6;">american </ins><span>football and </span><del style="background:#ffe6e6;">reading books.¶<br>¶<br>I don\'t work as a web developer anymore</del><ins style="background:#e6ffe6;">watching movies</ins><span>.</span></pre>'
    end

    describe 'avatar upload' do
      it 'caches an uploaded avatar during validation errors' do
        visit edit_user_path @user

        # Upload a file
        fill_in 'user_avatar', with: base64_image[:data]

        # Trigger validation error
        fill_in 'user_email', with: ''
        click_button 'Update'
        expect(page).to have_flash('User could not be updated.').of_type :alert

        # Make validations pass
        fill_in 'user_email', with: 'john@example.com'

        click_button 'Update'

        expect(page).to have_flash 'User was successfully updated.'

        expect(File.basename(@user.reload.avatar.to_s)).to eq 'avatar.png'
      end

      it 'replaces a cached uploaded avatar with a new one after validation errors' do
        visit edit_user_path @user

        # Upload a file
        fill_in 'user_avatar', with: base64_image[:data]

        # Trigger validation error
        fill_in 'user_email', with: ''
        click_button 'Update'
        expect(page).to have_flash('User could not be updated.').of_type :alert

        # Upload another file
        find('#user_avatar', visible: false).set base64_other_image[:data]

        # Make validations pass
        fill_in 'user_email', with: 'john@example.com'

        click_button 'Update'

        expect(page).to have_flash 'User was successfully updated.'
        expect(@user.reload.avatar.file.size).to eq base64_other_image[:size]
      end

      it 'allows to remove a cached uploaded avatar after validation errors' do
        visit edit_user_path @user

        # Upload a file
        fill_in 'user_avatar', with: base64_image[:data]

        # Trigger validation error
        fill_in 'user_email', with: ''
        click_button 'Update'
        expect(page).to have_flash('User could not be updated.').of_type :alert

        # Remove avatar
        check 'user_remove_avatar'

        # Make validations pass
        fill_in 'user_email', with: 'john@example.com'

        click_button 'Update'

        expect(page).to have_flash 'User was successfully updated.'
        expect(@user.reload.avatar.to_s).to eq ''
      end

      it 'allows to remove an uploaded avatar' do
        @user.update_attributes! avatar: File.open(dummy_file_path('image.jpg'))

        visit edit_user_path @user
        check 'user_remove_avatar'

        expect {
          click_button 'Update'
        }.to change { File.basename User.find(@user.id).avatar.to_s }.from('image.jpg').to eq '' # Here @user.reload works! Not the same as in https://github.com/carrierwaveuploader/carrierwave/issues/1752!

        expect(page).to have_flash 'User was successfully updated.'
      end
    end

    it 'allows to translate a user to German' do
      visit edit_user_path @user, locale: :de # Default locale (English)

      expect(page).to have_css 'textarea#user_about', text: 'Info about me.'
      fill_in 'user_about', with: 'Deutsches About.'

      expect {
        click_button 'Benutzer aktualisieren'
        @user.reload
      } .to  change { @user.about }.from('Info about me.').to('Deutsches About.')
        .and change { @user.about_de }.from(nil).to('Deutsches About.')
      expect(@user.about_en).to eq 'Info about me.'

      expect(page).to have_flash 'Benutzer wurde erfolgreich bearbeitet.'
    end
  end
end
