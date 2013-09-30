class Measure < ActiveRecord::Base
  has_many :taggings

  validates(:name, presence: true)
end
