class RatingSerializer

  include FastJsonapi::ObjectSerializer

  attributes :id, :score, :movie, :user, :description

  belongs_to :movie
  belongs_to :user

end
