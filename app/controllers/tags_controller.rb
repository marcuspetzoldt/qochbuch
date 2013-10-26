class TagsController < ApplicationController

  include ApplicationHelper

  before_action :is_admin?, only: [:index, :destroy]

  PAGINATION = 25

  def index
    @category = params[:default][:category] || 0
    @sort_by, @sort_direction = sort_by_column(tag: params[:tag], used: params[:used])
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

  def delete
    if params[:id].present?
      r = Tag.find(params[:id])
      if r
        r.destroy
      else
        flash[:error] = t('view.tags.invalid_tag_id')
      end
    end
    redirect_to tags_path

  end
end
