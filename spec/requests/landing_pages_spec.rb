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

    user = FactoryGirl.create(:user)
    new_user = User.new(name: 'test', email: 'new_user@test.de', password: 'secret', password_confirmation: 'secret')
    before do
      click_link('linkSignon')
    end

    it 'should open the signup form' do
      expect(page).to have_selector('div#formSignon')
    end

    it 'should close the signup form on cancel' do
      click_button('cancelSignon')
      sleep 2
      expect(page).not_to have_selector('div#formSignon')
    end

    it 'should close the signup form on successful submit' do
      fill_in('Name', with: new_user.name)
      fill_in('Email', with: new_user.email)
      fill_in('Password', with: new_user.password)
      fill_in('user_password_confirmation', with: new_user.password_confirmation)
      click_button('commitSignon')
      sleep 2
      expect(page).not_to have_selector('div#formSignon')
    end

    it 'should NOT close the signup form on UNsuccessful submit' do
      fill_in('Name', with: user.name)
      fill_in('Email', with: user.email)
      fill_in('Password', with: user.password)
      fill_in('user_password_confirmation', with: user.password_confirmation)
      click_button('commitSignon')
      sleep 2
      expect(page).to have_selector('div#formSignon')
    end
  end
end
