class User < ApplicationRecord
  
  acts_as_token_authenticatable

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :trackable

  has_many :ratings, dependent: :destroy

  validates :name, presence: true, length: { minimum: 2 }
  validates :email, presence: true, uniqueness: { case_sensitive: false }
  validates :role, presence: true, inclusion: { in: ['admin', 'member'] }
  validates :password, presence: true

  def admin?
    role === 'admin'
  end

  def member?
    role === 'member'
  end

  def invalidate_token
    self.update_columns(authentication_token: nil)
  end
   
end
