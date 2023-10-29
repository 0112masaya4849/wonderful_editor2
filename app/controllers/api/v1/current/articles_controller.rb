class Api::V1::Current::ArticlesController < Api::V1::BaseApiController
  before_action :authenticate_user!, only: :api_index
  def index
    # binding.pry
    @articles = Article.all
    articles = @articles
    @myarticles = current_user.articles.published.order(updated_at: :desc)
    # articles = Article.articles.published.order(updated_at: :desc)
    render json: @myarticles, each_serializer: Api::V1::ArticlePreviewSerializer
  end

end
