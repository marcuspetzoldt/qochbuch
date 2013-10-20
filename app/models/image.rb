class Image < ActiveRecord::Base
  before_save :pretty_name
  after_save :remove_obsolete_image
  before_destroy :destroy_image

  belongs_to :recipe

  attr_accessor :tmp_name

  validates(:public_id, presence: true)
  validates(:version, presence: true)

  def tmp_name=(n)
    if n.present?
      preloaded = Cloudinary::PreloadedFile.new(n)
      if preloaded.valid?
        self.public_id = preloaded.public_id
        self.version = preloaded.version
        @tmp_name = n
      end
    end
  end

  def name
    return "v#{self.version}/#{self.public_id}.jpg"
  end

  private

    def pretty_name
      if @changed_attributes.include?('public_id')
        @obsolete_image = @changed_attributes['public_id']
        old_public_id = self.public_id
        new_public_id = "qochbuch/#{self.recipe.id}/#{old_public_id}"
        Cloudinary::Uploader.rename(old_public_id, new_public_id, overwrite: true)
        self.public_id = new_public_id
      end
    end

    def remove_obsolete_image
      if @obsolete_image.present?
        Cloudinary::Uploader.destroy(@obsolete_image)
      end
    end

    def destroy_image
      Cloudinary::Uploader.destroy(public_id)
    end

end
