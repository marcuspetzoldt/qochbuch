class Recipe < ActiveRecord::Base
  after_save { save_images }
  belongs_to :user
  has_one :vote

  validates(:time, presence: true, format: { with: /\A[1-9][0-9]*\z/ })
  validates(:level, presence: true, inclusion: { in: 0..4 })
  validates(:title, presence: true, length: { maximum: 40 })
  validates(:description, presence: false, length: { maximum: 200 })
  validates(:directions, presence: true)

  def self.levels
    ['Simpel', 'Leicht', 'Normal', 'Schwer', 'Sehr schwer']
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

  def rating
    if id
      return Vote.where(recipe_id: id).average(:vote)
    else
      return 0
    end
  end

  private

    def save_images
      image_path = Rails.root.join('public', 'uploads', id.to_s)
      FileUtils.mkdir(image_path) unless File.exists?(image_path)
      Dir.glob(Rails.root.join('public', 'uploads', "#{user.id}_*")).each do |file|
        FileUtils.mv(file, image_path, force: true)
      end
    end

end
