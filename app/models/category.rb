class Category < ApplicationRecord

  validates_presence_of :title

  has_many :movies

  scope :sub_category, -> (slug, sub_category_slug) {
			where("slug = ? AND sub_category_slug = ?", slug, sub_category_slug)
		}

end
