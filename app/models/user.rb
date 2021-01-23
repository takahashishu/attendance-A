class User < ApplicationRecord
  has_many :attendances, dependent: :destroy # ユーザーが削除された場合、関連する勤怠データも同時に自動削除
  #「remember_token」という仮想の属性を作成する
  attr_accessor :remember_token
  before_save { self.email = email.downcase }
  
  validates :name, presence: true, length: { maximum: 50 }
  
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence: true, length: { maximum: 100 },
                    format: { with: VALID_EMAIL_REGEX },
                    uniqueness: true
  validates :department, length: { in: 2..30 }, allow_blank: true # 値が空文字""の場合バリデーションをスルー
  validates :basic_time, presence: true
  validates :work_time, presence: true
  has_secure_password # railsのメソッド。モデルにpassword_digestというカラムを含めることで使用可能。
  validates :password, presence: true, length: { minimum: 6 }, allow_nil: true # パスワードが入力されていない場合検証をスルーして更新
  
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
  　return false if remember_digest.nil? # ダイジェストが存在しない場合はfalseを返して終了する
    BCrypt::Password.new(remember_digest).is_password?(remeber_token)
  end
  
   # ユーザーのログイン情報を破棄する
  def forget
    update_attribute(:remember_digest, nil)
  end
  
  def self.search(search) # ここでのself.はUserを意味する
    if search
      where(['name LIKE?', "%#{search}%"]) # 検索とnameの部分一致を表示。User.は省略
    else
      all # 全て表示、User.は省略
    end
  end
end

