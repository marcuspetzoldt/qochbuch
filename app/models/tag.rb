class Tag < ActiveRecord::Base
  has_many :taggings
  has_many :recipes, through: :taggings

  validates(:category, presence: true, inclusion: { in: 0..2 })
  validates(:tag, presence: true, length: { maximum: 60 })
  validates(:other, presence: false, length: { maximum: 60 })

  def self.categories
    [I18n.t('views.tags.regions'), I18n.t('views.tags.tags'), I18n.t('views.tags.ingredients')]
  end

  def taglet
    if father
      [self] + Tag.find_by(id: father).taglet
    else
      [self]
    end
  end

end
