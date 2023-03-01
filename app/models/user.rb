class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
         
  validates :name, uniqueness: true, length: { minimum: 2, maximum: 20}
  validates :introduction, length: { maximum: 50 }

  has_one_attached :profile_image

  has_many :books, dependent: :destroy
  has_many :favorites, dependent: :destroy
  has_many :book_comments, dependent: :destroy

  ## 中間テーブルrelationships(フォローする)とreverse_of_relationships(フォローされる)を作成
  ## Relationshipモデルから外部キーfollower_idを参照にしてrelationshipsという名前の架空のテーブルを作成する
  has_many :relationships, class_name: "Relationship", foreign_key: "follower_id", dependent: :destroy
  
  ## Relationshipモデルから外部キーfollowed_idを参照にしてreverse_of_relationshipsという名前の架空のテーブルを作成する
  has_many :reverse_of_relationships, class_name: "Relationship", foreign_key: "followed_id", dependent: :destroy

  ## 一覧ページで使う
  ## followingsという名前で架空のテーブルを飛ばしてrelationship.rbファイルのfollowedを参照する
  has_many :followings, through: "relationships", source: :followed

  ## followersという名前で架空のテーブルを飛ばしてrelationship.rbファイルのfollowerを参照する
  has_many :followers,  through: "reverse_of_relationships", source: :follower

  ## フォローする(指定した引数user_idからfollowed_idに対して値を生成する（1人のユーザーが誰かをフォローしたという情報をidで生成する。)
  def follow(user_id)
    relationships.create(followed_id: user_id)
  end

  ## Relationshipのidを削除する
  def unfollow(user_id)
    relationships.find_by(followed_id: user_id).destroy
  end

  ## フォローしてるかを指定した引数userから判定
  def following?(user)
    followings.include?(user)
  end
  
  def get_profile_image(width, height)
    unless profile_image.attached?
      file_path = Rails.root.join('app/assets/images/no_image.jpg')
      profile_image.attach(io: File.open(file_path), filename: 'default-image.jpg', content_type: 'image/jpeg')
    end
    profile_image.variant(resize_to_limit: [width, height]).processed
  end

  def self.looks(search, word)
    if search == "perfect"
      User.where(name: word)
    elsif search == "forward"
      User.where("name LIKE ?", word + "%")
    elsif search == "backward"
      User.where("name LIKE ?", "%" + word)
    else
      User.where("name LIKE ?", "%" + word + "%")
    end
  end
  
end
