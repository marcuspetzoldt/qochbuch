class Tagging < ActiveRecord::Base
  belongs_to :recipe
  belongs_to :tag
  belongs_to :measure
end
