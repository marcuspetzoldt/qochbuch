class TagsController < ApplicationController

  include ApplicationHelper
  include TagsHelper

  before_action :require_admin

  PAGINATION = 3

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
    redirect_to path_from_category(c, just_edited: @tag.id)
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
    redirect_to path_from_category(c, just_edited: @tag.id)
  end

  def merge
    if session[:prepare_merge] && session[:prepare_merge].count > 1
      merge_to = session[:prepare_merge].first
      Tagging.where(tag_id: session[:prepare_merge][1..-1]).update_all(tag_id: merge_to)
      Tag.where(id: session[:prepare_merge][1..-1]).destroy_all
      session[:prepare_merge] = nil
      redirect_to ingredients_path(just_edited: merge_to)
      return
    end
    redirect_to ingredients_path
  end

  def prepare_merge
    if params[:remove]
      session[:prepare_merge].delete(params[:id])
    else
      session[:prepare_merge] = [] if session[:prepare_merge].nil?
      session[:prepare_merge] << params[:id]
    end
    redirect_to ingredients_path(page: params[:page])
  end

  def index
    @category = 0
    @just_edited = params[:just_edited].to_i if params[:just_edited]
    if session[:prepare_merge]
      @tags_to_merge = Tag.find(session[:prepare_merge])
    end
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
    if @just_edited
      where = t.index(Tag.find(@just_edited)) + 1
      @page = where / PAGINATION - ((where % PAGINATION > 0) ? 0 : 1)
    else
      @page = params[:page] ? params[:page].to_i : 0
    end
    @max_page = t.count / PAGINATION - ((t.count % PAGINATION > 0) ? 0 : 1)
    @tags = t[@page*PAGINATION..@page*PAGINATION+PAGINATION-1]
  end

  def destroy
    c = 0
    if params[:id].present?
      r = Tag.find(params[:id])
      if r
        c = r.category
        if r.taggings.count == 0
          r.destroy
        else
          flash[:error] = t('views.tags.invalid_tag_has_recipes')
        end
      else
        flash[:error] = t('views.tags.invalid_tag_id')
      end
    end
    redirect_to path_from_category(c)
  end

  private

    def tag_params
      params.require(:tag).permit(:tag, :other, :category)
    end
end
