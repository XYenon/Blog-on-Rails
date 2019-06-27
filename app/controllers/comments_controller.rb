class CommentsController < ApplicationController
  skip_before_action :require_login, only: :index

  before_action :set_comment, only: %i[edit update destroy]
  before_action only: %i[edit update] do
    require_self(@comment)
  end
  before_action only: :destroy do
    require_self_or_admin(@comment)
  end

  def index
    user_id = params[:user_id]
    @page = if params[:page].nil?
              1
            else
              Integer(params[:page])
            end
    count = Comment.count
    if user_id.nil?
      @comments = Comment.limit(10).offset(10 * @page - 10)
    else
      begin
        @user = User.find(user_id)
        @comments = @user.comments.limit(10).offset(10 * @page - 10)
        count = @user.comments.count
      rescue ActiveRecord::RecordNotFound
        @comments = []
      end
    end
    @page_count = if (count % 10).zero?
                    count / 10
                  else
                    count / 10 + 1
                  end
  end

  def edit
    render 'edit'
  end

  def create
    @article = Article.find(params[:article_id])
    article_id = Integer(params[:article_id])
    user_id = current_user.id
    body = comment_params['body']
    @comment = Comment.create(user_id: user_id, article_id: article_id, body: body)
    if @comment.save
      redirect_to article_path(@article), notice: 'Comment was successfully created.'
    else
      render 'edit'
    end
  end

  def update
    @article = @comment.article
    if @comment.update(comment_params)
      redirect_back fallback_location: root_path, notice: 'Comment was successfully updated.'
    else
      render 'edit'
    end
  end

  def destroy
    @comment.destroy
    redirect_back fallback_location: root_path, notice: 'Comment was successfully destroyed.'
  end

  private

  def comment_params
    params.require(:comment).permit(:body)
  end

  def set_comment
    @comment = Comment.find(params[:id])
  end
end
