class Post < ApplicationRecord
  belongs_to :user
  has_many :reverses_of_favorites, class_name: 'Favorite', foreign_key: 'post_id',dependent: :destroy
  has_many :users, through: :favorites, source: :user
  
  validates :content, presence: true, length: { maximum: 255 }
end
