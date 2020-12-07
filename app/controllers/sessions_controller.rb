class SessionsController < ApplicationController
  def new
  end
  
  def create
    user = User.find_by(email: params[:session][:email].downcase) #downcaseメソッドは大文字を小文字として判定する
    if user && user.authenticate(params[:session][:password]) #&&は取得したユーザーオブジェクトが有効か判定するために使用する
      log_in user
      redirect_to user
    else
      flash.now[:danger] = "認証に失敗しました。"
      render :new
    end
  end
  
  def destroy
    log_out
    flash[:success] = "ログアウトしました。"
    redirect_to root_url
  end
end
