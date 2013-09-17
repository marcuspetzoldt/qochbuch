require 'spec_helper'
describe "LandingPages" do

  before {visit root_path}
  describe "Home page" do

    it "should have the title 'qochbuch'" do
      expect(page).to have_title('qochbuch')
    end

    it "should have the navigation bar at the top" do
      expect(page).to have_css('div.navbar-fixed-top')
    end

    it "should have the status bar at the bottom" do
      expect(page).to have_css('div.navbar-fixed-bottom')
    end

  end

  describe 'Signup', js: true do

    it 'should open the signup form' do
      click_link('linkSignon')
#     expect(find_by_id('formSignon')).not_to be_nil
      expect(page).to have_selector('div#formSignon')
    end

    it 'should close the signup form on cancel' do
      click_link('linkSignon')
      click_button('Abbrechen')
      sleep 2
      expect(page).not_to have_selector('div#formSignon')
    end

    it 'should close the signup form on successful submit' do
      click_link('linkSignon')
      fill_in('Name', with: 'Test')
      fill_in('Email', with: 'test@test.de')
      fill_in('Password', with: 'kennwort')
      fill_in('user_password_confirmation', with: 'kennwort')
      click_button('Account anlegen')
      sleep 2
      expect(page).not_to have_selector('div#formSignon')
    end

    it 'should NOT close the signup form on UNsuccessful submit' do
      click_link('linkSignon')
      click_button('Account anlegen')
      sleep 2
      expect(page).to have_selector('div#formSignon')
    end
  end
end
