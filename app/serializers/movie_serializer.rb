class MovieSerializer

  include FastJsonapi::ObjectSerializer
  
  attributes :id, :title, :description, :image_url, :ratings, :visible

  belongs_to :category
  has_many :ratings

  attribute :current_user_rating do |object, params|
    if params[:user]
      userRating = Rating.where(
        	"movie_id = ? AND user_id = ?",
        	object.id,
        	params[:user].id
        ).first
    end
  end

  attribute :average_rating do |object|
    Rating.where("movie_id = ? AND score != 0", object.id).average(:score)
  end

end