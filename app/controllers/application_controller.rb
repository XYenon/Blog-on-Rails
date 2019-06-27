class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  helper_method %i[logged_in? self? admin? self_or_admin?]

  before_action :require_login
  before_action :user
  before_action :v_user

  def image_to_base64(file)
    Base64.encode64(File.read(file))
  end

  private

  def user
    @current_user = current_user
  end

  def v_user
    @user = if current_user.nil?
              User.new
            else
              current_user
            end
  end

  def current_user_session
    return @current_user_session if defined? @current_user_session
    @current_user_session = UserSession.find
  end

  def current_user
    return @current_user if defined? @current_user
    @current_user = current_user_session && current_user_session.user
  end

  def logged_in?
    !!current_user_session
  end

  def self?(item)
    return false unless logged_in?

    if item.class == User
      item == @current_user
    else
      item.user == @current_user
    end
  end

  def admin?
    return false unless logged_in?

    @current_user.admin
  end

  def self_or_admin?(item)
    return false unless logged_in?

    if item.class == User
      item == @current_user
    else
      item.user == @current_user || @current_user.admin
    end
  end

  def require_login
    redirect_to login_path unless logged_in?
  end

  def require_self(item)
    redirect_to root_path, status: 403 unless self?(item)
  end

  def require_admin
    redirect_to root_path, status: 403 unless admin?
  end

  def require_self_or_admin(item)
    redirect_to root_path, status: 403 unless self_or_admin?(item)
  end
end
