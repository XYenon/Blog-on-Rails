class TagsController < ApplicationController
  skip_before_action :require_login, only: %i[index show]

  def index
    @tags = Tag.all
  end

  def show
    @tags = Tag.all
    @tag = @tags.find_by_name(params[:name])
    @page = if params[:page].nil?
              1
            else
              Integer(params[:page])
            end
    count = @tag.articles.count
    @articles = @tag.articles.limit(10).offset(10 * @page - 10)
    @page_count = if (count % 10).zero?
                    count / 10
                  else
                    count / 10 + 1
                  end
  end

  private

  def tag_params
    params.require(:tag).permit(:name)
  end
end
