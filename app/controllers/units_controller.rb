class UnitsController < ApplicationController

  include ApplicationHelper

  before_action :signed_in?, except: [:index, :destroy]
  before_action :is_admin?, only: [:index, :destroy]

  PAGINATION = 25

  def new
    @unit = Unit.new
  end

  def create
    if params[:commit]
      @unit = Unit.new(unit_params)
      unless @unit.save
        render :new
        return
      end
    end
    redirect_to units_path
  end

  def edit
    @unit = Unit.find(params[:id])
    render :new
  end

  def update
    if params[:commit]
      @unit = Unit.find(params[:id])
      unless @unit.update(unit_params)
        render :new
        return
      end
    end
    redirect_to units_path
  end

  def index
    @sort_by, @sort_direction = sort_by_column(name: params[:tag], other: params[:other], used: params[:used])
    if @sort_by == :used
      if @sort_direction == 1
        r =
            Unit.all.sort do |a,b|
              a.taggings.count <=> b.taggings.count
            end
      else
        r =
            Unit.all.sort do |a,b|
              b.taggings.count <=> a.taggings.count
            end
      end
    else
      r = Unit.all.order(@sort_by => (@sort_direction == 1 ? :asc : :desc))
    end
    @page = params[:page] ? params[:page].to_i : 0
    @max_page = r.count / PAGINATION - 1
    @units = r[@page*PAGINATION..@page*PAGINATION+PAGINATION-1]
  end

  def destroy
    if params[:id].present?
      r = Unit.find(params[:id])
      if r
        r.destroy
      else
        flash[:error] = t('view.units.invalid_unit_id')
      end
    end
    redirect_to units_path
  end

  private

  def unit_params
    params.require(:unit).permit(:name, :other)
  end
end
