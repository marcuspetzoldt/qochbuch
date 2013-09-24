require 'spec_helper'

describe 'Signing on a user', js: true do

  before do
    new_user = User.new(name: 'test', email: 'new_user@test.de', password: 'secret', password_confirmation: 'secret')
    user = FactoryGirl.create(:user)
    visit(root_path)
    click_link('linkSignon')
  end

  describe 'Sign in' do

    it 'should open the sign in form' do
      expect(page).to have_selector('div#formSignon')
      expect(page).to have_field('Email')
      expect(page).to have_field('Password')
      expect(page).not_to have_field('Name')
      expect(page).not_to have_field('user_password_confirmation')
    end

    it 'should close the sign in form on cancel' do
      click_button('cancelSignon')
      sleep(2)
      expect(page).not_to have_selector('div#formSignon')
    end

    describe 'Successful log in' do
      before do
        sign_in(user)
      end

      it 'should close the sign in form on successful submit' do
        expect(page).not_to have_selector('div#formSignon')
        expect(page).to have_button(user.name)
      end

      describe 'User menu' do
        before do
          click_button(user.name)
        end
        describe "Sign out" do
          it 'should have a working sign out link' do
            expect(page).to have_link('linkSignout', href: signout_path)
            click_link('linkSignout')
            expect(page).to have_link('linkSignon', href: signin_path)
          end
        end

        describe 'Change Password' do
          before do
            click_link('linkChangePassword')
          end
=begin
          it 'Successful password change' do
            expect(page).to have_selector('div#formChangePassword')
            fill_in('password', with: user.password)
            fill_in('user_password', with: 'newpassword')
            fill_in('user_password_confirmation', with: 'newpassword')
            click_button('commit')
            sleep(2)
            expect(page).not_to have_selector('div#formChangePassword')
            expect(user.reload.authenticate('newpassword')).to eq user
          end
=end

          it 'Unsuccessful password change (new passwords don\'t match)' do
            expect(page).to have_selector('div#formChangePassword')
            fill_in('password', with: user.password)
            fill_in('user_password', with: 'newpassword')
            fill_in('user_password_confirmation', with: 'wrongpassword')
            click_button('commit')
            sleep(2)
            expect(page).to have_selector('div#formChangePassword')
            expect(page).to have_selector('div.alert.alert-error')
          end

          it 'Unsuccessful password change (wrong password given)' do
            expect(page).to have_selector('div#formChangePassword')
            fill_in('password', with: user.password)
            fill_in('user_password', with: 'newpassword')
            fill_in('user_password_confirmation', with: 'wrongpassword')
            click_button('commit')
            sleep(2)
            expect(page).to have_selector('div#formChangePassword')
            expect(page).to have_selector('div.alert.alert-error')
          end

          it 'should close form on cancel' do
            expect(page).to have_selector('div#formChangePassword')
            click_button('cancel')
            sleep(2)
            expect(page).not_to have_selector('div#formChangePassword')
          end
        end
      end
    end

    describe 'Unsuccessful log in' do

      it 'should NOT close the sign in form on unsuccessful submit' do
        fill_in('Email', with: user.email)
        fill_in('Password', with: 'wrong password')
        click_button('commitSignon')
        sleep(2)
        expect(page).to have_selector('div#formSignon')
        expect(page).to have_selector('div.alert.alert-error', text: 'Invalid user / password combination.')
      end
    end
  end

  describe 'Sign up' do
    before {
      click_link('linkSignup')
    }

    it 'should open the sign up form' do
      expect(page).to have_selector('div#formSignon')
      expect(page).to have_field('Email')
      expect(page).to have_field('Password')
      expect(page).to have_field('Name')
      expect(page).to have_field('user_password_confirmation')
    end

    it 'should close the sign up form on cancel' do
      click_button('cancelSignon')
      sleep(2)
      expect(page).not_to have_selector('div#formSignon')
    end

    describe 'Successful sign up' do
      before {
        fill_in('Name', with: new_user.name)
        fill_in('Email', with: new_user.email)
        fill_in('Password', with: new_user.password)
        fill_in('user_password_confirmation', with: new_user.password)
        click_button('commitSignon')
        sleep(2)
      }

      it 'should close the sign up form on successful submit' do
        expect(page).not_to have_selector('div#formSignon')
        expect(page).to have_button(new_user.name)
      end

    end

    describe 'Unsuccessful log in' do

      it 'should NOT close the sign up form on unsuccessful submit' do
        click_button('commitSignon')
        sleep(2)
        expect(page).to have_selector('div#formSignon')
        expect(page).to have_selector('div.alert.alert-error')
      end
    end

  end

end
