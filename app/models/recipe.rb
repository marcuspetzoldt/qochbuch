class Recipe < ActiveRecord::Base

  belongs_to :user
  has_one :vote
  has_many :taggings
  has_many :tags, through: :taggings
  has_many :images, dependent: :destroy
  accepts_nested_attributes_for :images, limit: 3

  attr_accessor :tagslist
  attr_accessor :regionslist

  validates(:time, presence: true, format: { with: /\A[1-9][0-9]*\z/ })
  validates(:level, presence: true, inclusion: { in: 0..4 })
  validates(:title, presence: true, length: { maximum: 40 })
  validates(:description, presence: false, length: { maximum: 200 })
  validates(:directions, presence: true)
  validates(:portion, presence: true)
  validates(:tagslist, presence: true)
  validates(:regionslist, presence: true)

  def self.levels
    [ I18n.t('activerecord.attributes.recipe.levels.l0'),
      I18n.t('activerecord.attributes.recipe.levels.l1'),
      I18n.t('activerecord.attributes.recipe.levels.l2'),
      I18n.t('activerecord.attributes.recipe.levels.l3'),
      I18n.t('activerecord.attributes.recipe.levels.l4') ]
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
      Recipe.find_by(id: matching_recipes[@position_in_resultset+i])
    end.compact
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
    @matching_recipes ||= all.ids.shuffle
  end

  private

    @position_in_resultset = 0

end
