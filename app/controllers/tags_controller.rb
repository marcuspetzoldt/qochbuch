class TagsController < ApplicationController

  include ApplicationHelper
  include TagsHelper

  before_action :require_admin

  PAGINATION = 25

  def new
    @tag = Tag.new(category: params[:category])
  end

  def create
    c = params[:tag][:category] || 0
    if params[:commit]
      @tag = Tag.new(tag_params)
      unless @tag.save
        render :new
        return
      end
    end
    redirect_to path_from_category(c)
  end

  def edit
    @tag = Tag.find(params[:id])
    render :new
  end

  def update
    c = params[:tag][:category] || 0
    if params[:commit]
      @tag = Tag.find(params[:id])
      unless @tag.update(tag_params)
        render :new
        return
      end
    end
    redirect_to path_from_category(c)
  end

  def merge
    m = params[:merge].map { |e| e[0] }
    if m && m.count > 1
      Tagging.where(tag_id: m[1..-1]).update_all(tag_id: m[0])
      Tag.where(id: m[1..-1]).destroy_all
    end
    redirect_to ingredients_path(merged: m[0])
  end

  def index
    if params[:merged]
      @merged = params[:merged].to_i
    end
    @category = 0
    if params[:default] && params[:default][:category]
      @category = params[:default][:category]
    end
    @sort_by, @sort_direction = sort_by_column(tag: params[:tag], other: params[:other], used: params[:used])
    if @sort_by == :used
      if @sort_direction == 1
        t =
            Tag.where(category: @category).sort do |a,b|
              a.taggings.count <=> b.taggings.count
            end
      else
        t =
            Tag.where(category: @category).sort do |a,b|
              b.taggings.count <=> a.taggings.count
            end
      end
    else
      t = Tag.where(category: @category).order(@sort_by => (@sort_direction == 1 ? :asc : :desc))
    end
    @page = params[:page] ? params[:page].to_i : 0
    @max_page = t.count / PAGINATION - ((t.count % PAGINATION > 0) ? 0 : 1)
    @tags = t[@page*PAGINATION..@page*PAGINATION+PAGINATION-1]
  end

  def destroy
    if params[:id].present?
      r = Tag.find(params[:id])
      if r
        if r.taggings.count == 0
          r.destroy
        else
          flash[:error] = t('views.tags.invalid_tag_has_recipes')
        end
      else
        flash[:error] = t('view.tags.invalid_tag_id')
      end
      case r.category
      when 0
        redirect_to regions_path
      when 1
        redirect_to categories_path
      when 2
        redirect_to ingredients_path
      end
    else
      redirect_to tags_path
    end
  end

  private

    def tag_params
      params.require(:tag).permit(:tag, :other, :category)
    end
end
