class SearchController < ApplicationController
  skip_before_action :require_login

  def index
    render 'index'
  end

  def articles
    keyword = search_params['keyword']
    @articles = if keyword.nil?
                  []
                else
                  search_articles(keyword)
                end
  end

  def users
    username = search_params['username']
    @users = if username.nil?
               []
             else
               search_users(username)
             end
  end

  private

  def search_params
    params.permit(:keyword, :enable_title, :enable_content,
                  :enable_user, :enable_tag, :username)
  end

  def search_articles(keyword)
    if search_params[:enable_title].nil? &&
        search_params[:enable_content].nil? &&
        search_params[:enable_user].nil? &&
        search_params[:enable_tag].nil?
      enable_title = true
      enable_content = true
      enable_user = true
      enable_tag = true
    else
      enable_title = search_params[:enable_title]
      enable_content = search_params[:enable_content]
      enable_user = search_params[:enable_user]
      enable_tag = search_params[:enable_tag]
    end
    articles = []
    articles += search_by_title(keyword) if enable_title
    articles += search_by_text(keyword) if enable_content
    articles += search_by_user(keyword) if enable_user
    articles += search_by_tag(keyword) if enable_tag
    articles.uniq
  end

  def search_users(username)
    username = '%' + username + '%'
    User.where('username LIKE ?', username)
  end

  def search_by_title(keyword)
    keyword = '%' + keyword + '%'
    Article.where('title LIKE ?', keyword)
  end

  def search_by_text(keyword)
    keyword = '%' + keyword + '%'
    Article.where('text LIKE ?', keyword)
  end

  def search_by_user(keyword)
    keyword = '%' + keyword + '%'
    users = User.where('username LIKE ?', keyword)
    articles = []
    users&.each do |user|
      articles += user.articles
    end
    articles.uniq
  end

  def search_by_tag(keyword)
    tags = Tag.where('name LIKE ?', keyword)
    articles = []
    tags&.each do |tag|
      articles += tag.articles
    end
    articles.uniq
  end
end
