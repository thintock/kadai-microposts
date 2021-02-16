class UsersController < ApplicationController
  before_action :require_user_logged_in, only: [:index, :show, :followings, :followers, :likes]
  before_action :set_user, only: [:show, :followings, :followers, :likes]
  
  def index
    @users = User.order(id: :desc).page(params[:page]).per(10)
  end

  def show
    @microposts = @user.microposts.order(id: :desc).page(params[:page])
    counts(@user)
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    
    if @user.save
      flash[:success] = "ユーザを登録しました。"
      redirect_to @user
    else
        flash.now[:danger] = "ユーザの登録に失敗しました。"
        render:new
    end
  end  
  
  def followings
    @followings = @user.followings.page(params[:page])
    counts(@user)
  end
  
  def followers
    @followers = @user.followers.page(params[:page])
    counts(@user)
  end
  
  def likes
    @microposts = @user.likes.page(params[:page])
    counts(@user)
  end
  
  private
  
  def user_params
    params.require(:user).permit(:name,:email,:password,:password_confirmation)
  end
  
  def set_user
    @user = User.find(params[:id])
  end
end
