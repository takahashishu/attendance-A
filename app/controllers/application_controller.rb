class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  include SessionsHelper
  
  $days_of_the_week = %w{日 月 火 水 木 金 土} # %w はRubyリテラル表記 ""の配列と同じように使用できる

  # beforeフィルター
  
  # paramsハッシュからユーザーを取得
  def set_user
    @user = User.find(params[:id])
  end
  
  
  # ログイン済みのユーザーか確認
  def logged_in_user
    unless logged_in? # 条件式がfalseの場合実行
      store_location
      flash[:danger] = "ログインして下さい。"
      redirect_to login_url
    end
  end
  
  
  # アクセスしたユーザーが現在ログインしているユーザーか確認
  def correct_user
    redirect_to(root_url) unless current_user?(@user)
  end
    
  def admin_user
    redirect_to root_url unless current_user.admin?
  end
 
  # ページ出力前に1ヶ月分のデータの存在を確認・セットします。
  def set_one_month 
    @first_day = params[:date].nil? ?
    Date.current.beginning_of_month : params[:date].to_date # 三項演算子 [条件式] ? [trueの場合実行される処理]:[falseの場合実行される処理]
    @last_day = @first_day.end_of_month
    one_month = [*@first_day..@last_day] # 対象の月の日数を代入します。
    # ユーザーに紐付く一ヶ月分のレコードを検索し取得します。
    @attendances = @user.attendances.where(worked_on: @first_day..@last_day).order(:worked_on)

    unless one_month.count == @attendances.count # それぞれの件数（日数）が一致するか評価します。
      ActiveRecord::Base.transaction do # トランザクションを開始します。トランザクションとは指定したブロックにあるデータベースへの操作が全部成功することを保証するための機能。データの整合性を保つために使用。
        # 繰り返し処理により、1ヶ月分の勤怠データを生成します。
        one_month.each { |day| @user.attendances.create!(worked_on: day) }
      end
      @attendances = @user.attendances.where(worked_on: @first_day..@last_day).order(:worked_on) # 実際に日付データを繰り返し処理で生成した後にも正しく@attendaces変数に値が代入されるようにするため2回定義している
    end

  rescue ActiveRecord::RecordInvalid # トランザクションによるエラーの分岐です。
    flash[:danger] = "ページ情報の取得に失敗しました、再アクセスしてください。"
    redirect_to root_url
  end
  
  # 管理権限者、または現在ログインしているユーザーを許可
    def admin_or_correct_user
      @user = User.find(params[:user_id]) if @user.blank?
      unless current_user?(@user) || current_user.admin?
       flash[:danger] = "編集権限がありません。"
       redirect_to(root_url)
      end
    end
end


