class LandingPagesController < ApplicationController

  include ApplicationHelper

  def home
    unless session[:search]
      session[:search] = Recipe.all_ids = Recipe.all.ids
    end
    @recipes = Recipe.suggestions
    @tags = cloud([0,1], Tag.where(id: session[:search]), false)
  end

  def next
    @recipes = Recipe.suggestions(1)
    @tags = cloud([0,1], Tag.where(id: session[:search]), false)
    render(:home)
  end

  def previous
    @recipes = Recipe.suggestions(-1)
    @tags = cloud([0,1], Tag.where(id: session[:search]), false)
    render(:home)
  end

  def help
  end

  def about
  end

  def search

    a = Recipe.all.ids

    if params[:isearch_used]
      tags = params[:isearch_used].strip.split(' ')
      if tags
        tags.each do |tag|
          a = a & (Tag.find(tag).recipes.map do |r| r.id end)
        end
      end
    end

    Recipe.all_ids = a.shuffle
    @recipes = Recipe.suggestions
    session[:search] = params[:isearch_used].strip.split(' ')
    @tags = cloud([0,1], Tag.where(id: session[:search]), false)
    render 'home'
  end

end
