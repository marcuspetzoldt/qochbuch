class TagsController < ApplicationController

  include ApplicationHelper

  before_action :is_admin?, only: [:index, :destroy]

  PAGINATION = 25

  def index
    @sort_by, @sort_direction = sort_by_column(tag: params[:tag], used: params[:used])
    if @sort_by == :used
      if @sort_direction == 1
        r =
            Tag.all.sort do |a,b|
              a.taggings.count <=> b.taggings.count
            end
      else
        r =
            Tag.all.sort do |a,b|
              b.taggings.count <=> a.taggings.count
            end
      end
    else
      r = Tag.all.order(@sort_by => (@sort_direction == 1 ? :asc : :desc))
    end
    @page = params[:page] ? params[:page].to_i : 0
    @max_page = r.count / PAGINATION - 1
    @tags = r[@page*PAGINATION..@page*PAGINATION+PAGINATION-1]
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
