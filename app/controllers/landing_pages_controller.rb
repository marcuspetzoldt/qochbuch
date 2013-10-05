class LandingPagesController < ApplicationController

  include ApplicationHelper

  def home
    session[:search_text] = nil
    session[:search_tags] = nil
    Recipe.matching_recipes = Recipe.all.ids
    @recipes = Recipe.suggestions
    @tags = cloud([0,1], Tag.where(id: session[:search]), false)
  end

  def next
    go_home(1)
  end

  def previous
    go_home(-1)
  end

  def search

    # TODO add results from tags
    session[:search_text] = params[:search_text].strip
    unless session[:search_text].blank?
      a = Recipe.where("MATCH(title, description, directions) AGAINST('#{session[:search_text]}' IN BOOLEAN MODE)").ids
    end

    session[:search_tags] = params[:isearch_used].strip
    tags = session[:search_tags].split(' ')
    unless tags.empty?
      b = Recipe.joins("JOIN taggings ON recipes.id = taggings.recipe_id JOIN tags ON taggings.tag_id = tags.id WHERE tags.id IN (#{tags.join(',')})").distinct.pluck(:id)
    end

    if a.nil?
      if b.nil?
        a = Recipe.all.ids
      else
        a = b
      end
    else
      unless b.nil?
        a = a & b
      end
    end

    Recipe.matching_recipes = a.shuffle
    go_home
  end

  private

    def go_home(direction=0)
      @recipes = Recipe.suggestions(direction)
      if session[:search_tags].nil?
        ids = []
      else
        ids = session[:search_tags].split(' ')
      end
      @tags = cloud([0,1], Tag.where(id: ids), false)
      render('home')
    end

end
