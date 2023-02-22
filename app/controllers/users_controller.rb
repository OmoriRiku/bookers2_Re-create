class UsersController < ApplicationController
  before_action :is_maching_login_user, only: [:edit, :update]
  
  def index
    @user = current_user
    @book = Book.new
    @users = User.all
  end

  def show
    @user = User.find(params[:id])
    @book = Book.new
    @book_show = @user.books
  end

  def edit
    @user = User.find(params[:id])
  end
  
  def update
    @user = User.find(params[:id])
    if @user.update(user_params)
      flash[:notice] = "User Update successfully"
      redirect_to user_path(@user)
    else
      render :edit
    end
  end
  
  private
  
  def is_maching_login_user
    user = User.find(params[:id])
    unless user == current_user
      redirect_to user_path(current_user)
    end
  end
  
  def user_params
    params.require(:user).permit(:name, :introduction, :profile_image)
  end
end
