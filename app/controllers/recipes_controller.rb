class RecipesController < ApplicationController

  def new
    if signed_in?()
      @recipe = Recipe.new
      @regions = cloud(0)
      @tags = cloud(1)
      respond_to do |format|
        format.html
      end
    else
      redirect_to(root_path)
    end
  end

  def create
    if params[:commit]
      @recipe = Recipe.new(recipe_params)
      @recipe.user_id = current_user.id
      if @recipe.save
        @recipe.tags = get_tags
        redirect_to @recipe
      else
        render('new')
      end
    else
      redirect_to(root_path)
    end
  end

  def edit
    @recipe = Recipe.find(params[:id])
    @regions = cloud(0)
    @tags = cloud(1)
    render('new')
  end

  def update
    if params[:commit]
      @recipe = Recipe.find(params[:id])
      if @recipe.update(recipe_params)
        @recipe.tags = get_tags
        redirect_to @recipe
      else
        render('new')
      end
    else
      redirect_to(recipe_path(params[:id]))
    end
  end

  def show
    @recipe = Recipe.find_by(id: params[:id])
    respond_to do |format|
      format.html
    end
  end

  def upload
    uploaded_io = nil
    nr = nil

    if params[:recipe][:pic1]
      uploaded_io = params[:recipe][:pic1]
      nr = 1
    else
      if params[:recipe][:pic2]
        uploaded_io = params[:recipe][:pic2]
        nr = 2
      else
        if params[:recipe][:pic3]
          uploaded_io = params[:recipe][:pic3]
          nr = 3
        end
      end
    end
    if uploaded_io
      file_name = "#{current_user.id}_#{nr}#{File.extname(uploaded_io.original_filename)}"
      File.open(Rails.root.join('public', 'uploads', file_name), 'wb') do |file|
        file.write(uploaded_io.read)
      end
    end
    render js: "$('img#pic#{nr}').attr('src', '/uploads/#{file_name}')"
  end

  private

    def recipe_params
      params.require(:recipe).permit(:time, :level,
        :title, :description, :directions)
    end

    def cloud(category)
      # get all tags categorized as category
      # normalize tag count

      used_tags = @recipe.tags.where(category: category).order(:tag)
      usable_tags = Tag.where(category: category).order(:tag) - used_tags
      used_tags.map! do |t| { id: t.id, tag: t.tag, font_size: t.recipes.count } end
      usable_tags.map! do |t| { id: t.id, tag: t.tag, font_size: t.recipes.count } end
      max_font_size = ((used_tags + usable_tags).max do |a,b| a[:font_size] <=> b[:font_size] end)[:font_size]
      if max_font_size == 0
        max_font_size = 1
      end
      factor = 24.0/max_font_size
      used_tags.each do |t| t[:font_size] = (t[:font_size]*factor).to_i + 12 end
      usable_tags.each do |t| t[:font_size] = (t[:font_size]*factor).to_i + 12 end
      Rails.logger.info("In Benutzung: #{used_tags.count}")
      return { used: used_tags, usable: usable_tags }
    end

    def get_tags
      tag_ids = (params[:recipe][:regions].strip + ' ' + params[:recipe][:tags].strip).split(' ')
      Tag.where(id: tag_ids)
    end

end
