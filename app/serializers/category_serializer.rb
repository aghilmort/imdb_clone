class CategorySerializer

  include FastJsonapi::ObjectSerializer

  attributes :id, :title, :slug, :sub_category_title, :sub_category_slug, :description, :image_url

  has_many :movies

end
