class Unit < ActiveRecord::Base
  has_many :taggings

  validates :name, length: { maximum: 20 }
  validates :other, length: { maximum: 20 }
  validates :rule, inclusion: { in: 0..2 }

  def self.rules
    ['immer Singular',
     'immer Plural',
     'Plural und Singular']
  end

end