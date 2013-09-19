require 'spec_helper'

describe 'Signing on a user', js: true do

  user = FactoryGirl.create(:user)
  new_user1 = User.new(name: 'test', email: 'new_user1@test.de', password: 'secret', password_confirmation: 'secret')
  new_user2 = User.new(name: 'test', email: 'new_user2@test.de', password: 'secret', password_confirmation: 'secret')
  before do
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
      sleep 2
      expect(page).not_to have_selector('div#formSignon')
    end

    describe 'Successful log in' do
      before do
        fill_in('Email', with: user.email)
        fill_in('Password', with: user.password)
        click_button('commitSignon')
        sleep 2
      end

      it 'should close the sign in form on successful submit' do
        expect(page).not_to have_selector('div#formSignon')
        expect(page).to have_button(user.name)
      end

      describe 'User menu' do
        before {click_button(user.name)}
        it 'should have the sign out link' do
          expect(page).to have_link('Abmelden', href: signout_path)
        end
      end
    end

    describe 'Unsuccessful log in' do

      it 'should NOT close the sign in form on unsuccessful submit' do
        fill_in('Email', with: user.email)
        fill_in('Password', with: 'wrong password')
        click_button('commitSignon')
        sleep 2
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
      sleep 2
      expect(page).not_to have_selector('div#formSignon')
    end

    describe 'Successful sign up' do
      it 'should close the sign up form on successful submit' do
        fill_in('Name', with: new_user1.name)
        fill_in('Email', with: new_user1.email)
        fill_in('Password', with: new_user1.password)
        fill_in('user_password_confirmation', with: new_user1.password)
        click_button('commitSignon')
        sleep 2
        expect(page).not_to have_selector('div#formSignon')
        expect(page).to have_button(new_user1.name)
      end

      describe 'User menu' do
        it 'should have the sign out link' do
          fill_in('Name', with: new_user2.name)
          fill_in('Email', with: new_user2.email)
          fill_in('Password', with: new_user2.password)
          fill_in('user_password_confirmation', with: new_user2.password)
          click_button('commitSignon')
          sleep 2
          click_button(new_user2.name)
          expect(page).to have_link('Abmelden', href: signout_path)
        end
      end

    end

    describe 'Unsuccessful log in' do

      it 'should NOT close the sign up form on unsuccessful submit' do
        click_button('commitSignon')
        sleep 2
        expect(page).to have_selector('div#formSignon')
        expect(page).to have_selector('div.alert.alert-error')
      end
    end
  end

end
