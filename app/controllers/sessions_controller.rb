class SessionsController < ApplicationController
  def new
  end
  
  def create
    user = User.find_by(email: params[:session][:email].downcase) # downcaseメソッドは大文字を小文字として判定する
    if user && user.authenticate(params[:session][:password]) # &&は取得したユーザーオブジェクトが有効か判定するために使用する
      log_in user
      # checkboxの処理
      params[:session][:remember_me] == '1' ? remember(user) : forget(user) # 三項演算子 [条件式] ? [trueの場合実行される処理]:[falseの場合実行される処理]
      redirect_back_or user # 記憶しているURLが存在している場合そこにリダイレクトし、存在しない場合はデフォルトとして設定したURLにリダイレクトする
    else
      flash.now[:danger] = "認証に失敗しました。"
      render :new
    end
  end
  
  def destroy
    # ログイン中の場合のみログアウト処理を実行する
    log_out if logged_in?
    flash[:success] = "ログアウトしました。"
    redirect_to root_url
  end
end
