class Book < ApplicationRecord
  
  belongs_to :user
  has_many :favorites, dependent: :destroy
  has_many :book_comments, dependent: :destroy
  
  validates :title, presence: true
  validates :body, presence: true, length: { maximum: 200 }

  ## FavoriteテーブルにユーザーIDが存在するか確認する
  def favorited_by?(user)
    favorites.exists?(user_id: user.id)
  end

  def self.looks(search, word)
    if search == "perfect"
      Book.where(title: word)
    elsif search == "foward"
      Book.where("title LIKE ? ", word + "%")
    elsif search == "backward"
      Book.where("title LIKE ? ", "%" + word )
    else
      Book.where("title LIKE ? ", "%" + word + "%")
    end
  end

end
