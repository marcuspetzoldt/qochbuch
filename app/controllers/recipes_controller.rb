class RecipesController < ApplicationController

  def new
    if signed_in?()
      @recipe = Recipe.new
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
        redirect_to @recipe
      else
        render('new')
      end
    else
      redirect_to(root_path)
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

end
