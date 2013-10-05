class Recipe < ActiveRecord::Base

  after_save { save_images }
  belongs_to :user
  has_one :vote
  has_many :taggings
  has_many :tags, through: :taggings
  accepts_nested_attributes_for :taggings
  accepts_nested_attributes_for :tags

  validates(:time, presence: true, format: { with: /\A[1-9][0-9]*\z/ })
  validates(:level, presence: true, inclusion: { in: 0..4 })
  validates(:title, presence: true, length: { maximum: 40 })
  validates(:description, presence: false, length: { maximum: 200 })
  validates(:directions, presence: true)
  validates(:portion, presence: true)

  def self.levels
    ['Sehr leicht', 'Leicht', 'Normal', 'Schwer', 'Sehr schwer']
  end

  def self.suggestions(direction=0)

    if direction > 0
      # next three recipes from shuffled matching_recipes
      @position_in_resultset += 3
      if @position_in_resultset >= matching_recipes.size
        @position_in_resultset = 0
      end
    end
    if direction < 0
      # previous three recipes from shuffled matching_recipes
      @position_in_resultset -= 3
      if @position_in_resultset < 0
        @position_in_resultset = 3 * matching_recipes.size.div(3)
      end
    end
    3.times.map do |i|
      Recipe.find_by(id: matching_recipes[@position_in_resultset+i]) || Recipe.new
    end
  end

  def self.image_name(for_recipe, image_nr)
    image_name = nil
    if for_recipe && for_recipe.id
      path = Pathname.glob(Rails.root.join('public', 'uploads', for_recipe.id.to_s, "#{for_recipe.user.id}_#{image_nr}.*"))[0]
      if path
        image_name = "/#{path.relative_path_from(Rails.root.join('public'))}"
      end
    end
    # Default to placeholder.png if image doesn't exist
    image_name ||= Pathname.new('/assets/placeholder.png')
    return image_name
  end

  # Average rating of given recipe, with two decimal places
  def rating
    (Vote.where(recipe_id: id).average(:vote) || 0.0).round(2)
  end

  def self.matching_recipes=(ids)
    @matching_recipes = ids
    @position_in_resultset = 0
  end

  # all ids matching the last search
  def self.matching_recipes
    @matching_recipes ||= all.ids
  end

  private

    @position_in_resultset = 0

    def save_images
      image_path = Rails.root.join('public', 'uploads', id.to_s)
      FileUtils.mkdir(image_path) unless File.exists?(image_path)
      Dir.glob(Rails.root.join('public', 'uploads', "#{user.id}_*")).each do |file|
        FileUtils.mv(file, image_path, force: true)
      end
    end

end
