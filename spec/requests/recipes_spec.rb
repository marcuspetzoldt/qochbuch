require 'spec_helper'

describe 'Recipes' do

  recipe = FactoryGirl.create(:recipe)

  describe "with signed in user", js: true do
    before do
      visit(root_path)
      click_link('linkSignon')
      sign_in(recipe.user)
    end

    describe 'Create a new recipe' do
      before do
        click_button(recipe.user.name)
        click_link('linkNewRecipe')
      end
      it 'should show the form for a new recipe' do
        expect(page).to have_selector('form#new_recipe')
        expect(page).to have_field('recipe_pic1')
        expect(page).to have_field('recipe_pic2')
        expect(page).to have_field('recipe_pic3')
        expect(page).to have_field('recipe_time')
        expect(page).to have_field('recipe_level')
        expect(page).to have_field('recipe_title')
        expect(page).to have_field('recipe_description')
        expect(page).to have_selector('div#cke_recipe_directions')
        expect(page).to have_button('commit')
        expect(page).to have_button('cancel')
      end

      describe 'with valid input' do
        it 'should create a new recipe' do
          fill_in('recipe_time', with: 1234)
          select(Recipe.levels[1], from: 'recipe_level')
          fill_in('recipe_title', with: 'RecipeTitle')
          fill_in('recipe_description', with: 'RecipeDescription')
          fill_in_ckeditor('recipe_directions', with: 'RecipeDirections')
          click_button('commit')
          expect(page).not_to have_selector('form#new_recipe')
          expect(page).to have_content('1234')
          expect(page).to have_content(Recipe.levels[1])
          expect(page).to have_content('RecipeTitle')
          expect(page).to have_content('RecipeDescription')
          expect(page).to have_content('RecipeDirections')
        end
      end

      describe 'with invalid input' do
        it 'should show an error message' do
          click_button('commit')
          expect(page).to have_selector('form#new_recipe')
          expect(page).to have_selector('div.alert.alert-error')
        end
      end
    end

    describe 'Show a recipe' do
      it 'should show a recipe' do
        visit(recipe_path(recipe))
        expect(page).to have_content(recipe.title)
      end
    end
  end

  describe 'with an anonymous user' do
    it 'should show a recipe' do
      visit(recipe_path(recipe))
      expect(page).to have_content(recipe.title)
    end

    it 'should not show the new recipe form' do
      visit(new_recipe_path)
      expect(page).not_to have_selector('form#new_recipe')
    end
  end
end
