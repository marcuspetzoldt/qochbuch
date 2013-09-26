class Vote < ActiveRecord::Base
  belongs_to :recipe
  belongs_to :user

  validates(:vote, presence: true, inclusion: { in: 0..5 })
end
