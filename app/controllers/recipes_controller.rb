class RecipesController < ApplicationController

  include ApplicationHelper

  before_filter :require_login, except: [:show, :calculate]

  def new
    @recipe = Recipe.new
    @recipe.user_id = current_user.id
    @regions = cloud(0, @recipe.tags.where(category: 0).order(:tag), true)
    @tags = cloud(1, @recipe.tags.where(category: 1).order(:tag), true)
    respond_to do |format|
      format.html
    end
  end

  def create
    # TODO: tags and regions must not be empty
    if params[:commit]
      @recipe = Recipe.new(recipe_params)
      @recipe.user_id = current_user.id
      if @recipe.save
        @recipe.tags = get_tags
        save_ingredients
        redirect_to @recipe
      else
        redisplay_form
      end
    else
      redirect_to(root_path)
    end
  end

  def edit
    @recipe = Recipe.find(params[:id])
    @regions = cloud(0, @recipe.tags.where(category: 0).order(:tag), true)
    @tags = cloud(1, @recipe.tags.where(category: 1).order(:tag), true)
    @ingredients = get_ingredients
    render('new')
  end

  def update
    if params[:commit]
      @recipe = Recipe.find(params[:id])
      if @recipe.update(recipe_params)
        @recipe.tags = get_tags
        save_ingredients
        redirect_to @recipe
      else
        redisplay_form
      end
    else
      redirect_to(recipe_path(params[:id]))
    end
  end

  def show
    @recipe = Recipe.find_by(id: params[:id])
    @ingredients = get_ingredients
    respond_to do |format|
      format.html
    end
  end

  def calculate
    @recipe = Recipe.find(params[:id])
    @ingredients = get_ingredients
    Rails.logger.info("calculate: #{params}")
    render 'calculate'
  end

  private

    def recipe_params
      params.require(:recipe).permit(:time, :level, :portion,
        :title, :description, :directions, images_attributes: [:id, :name, :tmp_name])
    end

    def get_tags
      tag_ids = (params[:recipe][:regions].strip + ' ' + params[:recipe][:tags].strip).split(' ')
      Tag.where(id: tag_ids)
    end

    def get_ingredients
      if params[:recipe]
        Rails.logger.info('get_ingredients')
        Rails.logger.info(params)
        ing = params[:recipe][:ingredients]
        1.upto(ing[:amount].count-1).map do |i|
          {amount: ing[:amount][i], unit_id: ing[:unit][i], unit: nil, tag: ing[:tag][i] }
        end
      else
        @recipe.taggings.map do |t|
          if t.tag.category == 2
            {amount: t.amount, unit_id: t.unit_id, unit: t.unit.name, tag: t.tag.tag }
          end
        end.compact
      end
    end

    def save_ingredients
      ing = params[:recipe][:ingredients]
      1.upto(ing[:amount].count-1) do |i|
        # Skip entries without an ingredient name
        unless ing[:tag][i].blank?
          tag = Tag.find_by(tag: ing[:tag][i])
          if tag.nil?
            tag = Tag.create(category: 2, father: nil, tag: ing[:tag][i])
          end
          Tagging.create(amount: ing[:amount][i], unit_id: ing[:unit][i].to_i, tag_id: tag.id, recipe_id: @recipe.id)
        end
      end
    end

    def redisplay_form
      @regions = cloud(0, Tag.where(id: params[:recipe][:regions].strip.split(' ')), true)
      @tags = cloud(1, Tag.where(id: params[:recipe][:tags].strip.split(' ')), true)
      @ingredients = get_ingredients
      render('new')
    end

end
