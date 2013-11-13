class LandingPagesController < ApplicationController

  include ApplicationHelper

  def home
    session[:search_text] = nil
    session[:search_tags] = nil
    Recipe.matching_recipes = Recipe.all.ids.shuffle
    @recipes = Recipe.suggestions
    @tags = cloud([0,1], nil, false)
  end

  def next
    go_home(1)
  end

  def previous
    go_home(-1)
  end

  def search

    if params[:search_my]
      # toggle only my recipes
      if session[:search_id]
        session[:search_id] = nil
      else
        session[:search_id] = current_user.id
      end
    end

    if params[:search_text]
      session[:search_text] = params[:search_text].strip
      unless session[:search_text].blank?
        # mysql
        # a = Recipe.where("MATCH(title, description, directions) AGAINST('#{session[:search_text]}' IN BOOLEAN MODE)").ids
        # postgresql
        a = Search.new(session[:search_text])
      end
    end

    if params[:isearch_used]
      session[:search_tags] = params[:isearch_used].strip
      tags = session[:search_tags].split(' ')
      unless tags.empty?
        b = Recipe.find_by_sql("SELECT DISTINCT r.id FROM recipes r JOIN taggings j ON r.id = j.recipe_id JOIN tags t on t.id = j.tag_id WHERE t.id IN (#{tags.join(',')}) GROUP BY r.id HAVING count(*) = #{tags.count}").map do |e| e.id end
      end
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
