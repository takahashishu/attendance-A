class User < ApplicationRecord
  #「remember_token」という仮想の属性を作成する
  attr_accessor :remember_token
  before_save { self.email = email.downcase }
  
  validates :name, presence: true, length: { maximum: 50 }
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence: true, length: { maximum: 100 },
                    format: { with: VALID_EMAIL_REGEX },
                    uniqueness: true
  has_secure_password
  validates :password, presence: true, length: { minimum: 6 }
  
  # 渡された文字列のハッシュ値を返す
  def User.digest(string)
    cost =
      if ActiveModel::SecurePassword.min_cost
        BCrypt::Enigne::MIN_COST
      else
        BCrypt::Engine.cost
      end
    BCrypt::Password.create(string, cost: cost)
  end
  
  # ランダムなトークンを返す
  def User.new_token
    SecureRandom.urlsafe_base64
  end
  
  # 永続セッションのためハッシュ化したトークンをデータベースに記憶する
  def remember
    self.remember_token = User.new_token # selfがなければremember_tokenというローカル変数が作成されてしまう
    update_attribute(:remember_digest, User.digest(remember_token)) # トークンダイジェストを更新(attributeにsをつけないことでバリデーションを素通りさせる)
  end
  
  # トークンがダイジェストと一致すればtrueを返す
  def authenticated?(remeber_token)
  　# ダイジェストが存在しない場合はfalseを返して終了
  　return false if remember_digest.nil?
    BCrypt::Password.new(remember_digest).is_password?(remeber_token)
  end
  
   # ユーザーのログイン情報を破棄する
  def forget
    update_attribute(:remember_digest, nil)
  end
end

