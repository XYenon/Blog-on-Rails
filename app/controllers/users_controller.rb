class UsersController < ApplicationController
  skip_before_action :require_login, only: %i[index new create]

  before_action :v_user, only: %i[show edit update destroy]
  before_action only: %i[show edit update destroy] do
    require_self_or_admin(@user)
  end

  def index
    @users = User.all
  end

  def show
    render 'show'
  end

  def new
    @user = User.new
  end

  def edit
    render 'edit'
  end

  def create
    @user = User.new(user_params)
    if @user.save
      redirect_to user_path, notice: 'User was successfully created.'
    else
      render :new
    end
  end

  def update
    temp_params = user_params
    if user_params[:gravatar] == '0' && !user_params[:avatar].nil?
      uploaded_io = user_params[:avatar]
      temp_params[:avatar] = "data:#{user_params[:avatar].content_type};base64,
                             #{Base64.strict_encode64(uploaded_io.read)}"
    end
    if @user.update(temp_params)
      redirect_to user_path, notice: 'User was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    @user.destroy
    redirect_to root_path, notice: 'User was successfully destroyed.'
  end

  private

  def user_params
    params.require(:user).permit(:username, :email, :profile, :password,
                                 :password_confirmation, :avatar, :gravatar)
  end
end
