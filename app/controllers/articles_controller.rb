# frozen_string_literal: true

class ArticlesController < ApplicationController
  skip_before_action :require_login, only: %i[index show]

  before_action :set_article, only: %i[show edit update destroy]
  before_action only: %i[edit update] do
    require_self(@article)
  end
  before_action only: :destroy do
    require_self_or_admin(@article)
  end

  before_action only: %i[update destroy] do
    @before_tags = Array.new(@article.tags)
  end
  after_action :tags_destroy_helper, only: %i[update destroy]

  def index
    user_id = params[:user_id]
    @page = if params[:page].nil?
              1
            else
              Integer(params[:page])
            end
    count = Article.count
    if user_id.nil?
      @articles = Article.limit(10).offset(10 * @page - 10)
    else
      begin
        @user = User.find(user_id)
        @articles = @user.articles.limit(10).offset(10 * @page - 10)
        count = @user.articles.count
      rescue ActiveRecord::RecordNotFound
        @articles = []
      end
    end
    @page_count = if (count % 10).zero?
                    count / 10
                  else
                    count / 10 + 1
                  end
  end

  def show
    @comment = Comment.new
    @comments = @article.comments
  end

  def new
    @article = Article.new
  end

  def edit
    @tags_str = ''
    @article.tags.each do |tag|
      @tags_str += tag.name + ' '
    end
    render 'edit'
  end

  def create
    tags = tags_helper(article_params['tags'], 'new')
    @article = Article.create(user_id: current_user.id,
                              title: article_params['title'],
                              text: article_params['text'])
    @article.tags = tags
    if @article.save
      redirect_to @article, notice: 'Article was successfully created.'
    else
      render 'new'
    end
  end

  def update
    tags = tags_helper(article_params['tags'], 'edit')
    @article.tags = tags
    if @article.update(user_id: current_user.id,
                       title: article_params['title'],
                       text: article_params['text'])
      redirect_to @article, notice: 'Article was successfully updated.'
    else
      render 'edit'
    end
  end

  def destroy
    @article.destroy
    redirect_to root_path, notice: 'Article was successfully destroyed.'
  end

  private

  def article_params
    params.require(:article).permit(:title, :text, :tags)
  end

  def set_article
    @article = Article.find(params[:id])
  end

  def tags_helper(tags_str, page)
    tags = []
    tags_str.split.each do |tag_str|
      tag = Tag.find_by_name(tag_str)
      if tag.nil?
        tag = Tag.create(name: tag_str)
        render page unless tag.save
      end
      tags.append(tag)
    end
    tags
  end

  def tags_destroy_helper
    @before_tags.each do |tag|
      puts tag.articles.any?
      tag.destroy unless tag.articles.any?
    end
  end
end
