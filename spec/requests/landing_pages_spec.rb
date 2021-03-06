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
end
