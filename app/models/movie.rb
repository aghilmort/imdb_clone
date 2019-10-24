class Movie < ApplicationRecord

  belongs_to :category
  has_many :ratings, dependent: :destroy

  validates_presence_of :title, :category

  attr_accessor :ratings

  scope :with_sub_category, -> (slug, sub_category_slug) {
			where(
				"categories.slug = ? AND categories.sub_category_slug = ?",
				slug,
				sub_category_slug
			)
		}

	scope :without_sub_category, -> (slug) { where("categories.slug = ?", slug) }

  def ratings
  	@ratings ||= Rating.where(movie_id: id)
  end

end
