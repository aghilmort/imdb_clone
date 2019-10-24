class UserSerializer

  include FastJsonapi::ObjectSerializer
  
  attributes :id, :name, :email, :role

  has_many :ratings

end
