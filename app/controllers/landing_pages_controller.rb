class LandingPagesController < ApplicationController
  def home
    @recipes = Recipe.suggestions(1)
  end

  def next
    @recipes = Recipe.suggestions(1)
    render(:home)
  end

  def previous
    @recipes = Recipe.suggestions(-1)
    render(:home)
  end

  def help
  end

  def about
  end
end
