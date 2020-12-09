module SessionsHelper
  
  # 引数に渡されたユーザーオブジェクトでログイン
  def log_in(user)
    session[:user_id] = user.id
  end
  
  # 永続的セッションを記憶する(Userモデルを参照)
  def remember(user)
    user.remember
    cookies.permanent.signed[:user_id] = user.id
    cookies.permanent[:remember_token] = user.remember_token
  end
  
  # 永続的セッションを破棄する
  def forget(user)
    user.forget # Userモデルを参照
    cookies.delete(:user_id)
    cookies.delete(:remember_token)
  end
  
  # セッションと@current_userを破棄する
  def log_out
    forget(current_user)
    session.delete(:user_id)
    @current_user = nil
  end
  
  # 一時的セッションにいるユーザーを返す
  # それ以外の場合はcookiesに対応するユーザーを返す
  def current_user
    if (user_id = session[:user_id])
      @current_user ||= User.find_by(id: user_id)
    elsif (user_id = cookies.signed[:user_id])
      user = User.find_by(id: user_id)
      if user && user.authenticated?(cookies[:remember_token])
        log_in user
        @current_user = user
      end
    end
  end
  
  # 現在ログインしているユーザーがいればtrue、そうでなければfalseを返す
  def logged_in?
    !current_user.nil? # !は否定演算子
  end
  
  # ログイン中の場合のみログアウト処理を実行する
  def destroy
    log_out if logged_in?
    flash[:success] = "ログアウトしました。"
    redirect_to root url
  end
    
end
