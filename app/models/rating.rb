class Rating < ApplicationRecord

  belongs_to :movie
  belongs_to :user

  validates :movie, presence: true
  validates :user, presence: true
	validates :score, presence: true

end
