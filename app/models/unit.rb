class Unit < ActiveRecord::Base
  has_many :taggings

  validates :name, length: { maximum: 20 }
  validates :other, length: { maximum: 20 }

end