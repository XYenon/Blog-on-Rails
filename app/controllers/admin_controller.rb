class AdminController < ApplicationController
  before_action :require_admin
  before_action :set_user, except: :index

  def index
    @users = User.all
    render 'index'
  end

  def show
    render 'show'
  end

  def edit
    render 'edit'
  end

  def update
    temp_params = admin_params
    if temp_params[:gravatar] == '0' && !temp_params[:avatar].nil?
      uploaded_io = user_params[:avatar]
      temp_params[:avatar] = "data:#{temp_params[:avatar].content_type};base64,
                             #{Base64.strict_encode64(uploaded_io.read)}"
    end
    if @user.update(temp_params)
      redirect_to admin_show_user_path, notice: 'User was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    @user.destroy
    redirect_to admin_path, notice: 'User was successfully destroyed.'
  end

  private

  def set_user
    @user = User.find(params[:id])
  end

  def admin_params
    params.require(:user).permit(:username, :email, :profile, :admin, :password,
                                 :password_confirmation, :avatar, :gravatar)
  end
end