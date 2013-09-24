class Recipe < ActiveRecord::Base
  after_save { save_images }
  belongs_to :user

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

  def rating_as_string
    # TODO: Rating Model
    n = 1
    "<span class=\"starsyellow big\">#{"&#x2605;"*(n-1)}</span><span class=\"starsgray big\">#{"&#x2605;"*(6-n)}</span>"
  end

  private

    def save_images
      image_path = Rails.root.join('public', 'uploads', id.to_s)
      FileUtils.mkdir(image_path)
      Dir.glob(Rails.root.join('public', 'uploads', "#{user.id}_*")).each do |file|
        FileUtils.mv(file, image_path)
      end
    end

end
