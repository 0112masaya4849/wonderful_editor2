module Api::V1
  class ArticlesController < BaseApiController
    def index
      articles = Article.order(updated_at: :desc)
      render json: articles, each_serializer: Api::V1::ArticlePreviewSerializer
    end

    def show
      #binding.pry
      article = Article.find(params[:id])
      render json: article, serializer: Api::V1::ArticleSerializer
    end

    def create
      # binding.pry
      article = current_user.articles.create!(article_params)
      render json: article, serializer: Api::V1::ArticleSerializer

    end

    def update
        article = current_user.articles.find(params[:id])
        article.update!(article_params)
        render json: article, serializer: Api::V1::ArticleSerializer
    end

    def destroy
        # 対象のレコードを探す
        # binding.pry
        article = current_user.articles.find(params[:id])
        # 探してきたレコードを削除する
        article.destroy!
        # json として値を返す
        render json: article, serializer: Api::V1::ArticleSerializer
    end


    private

    def article_params
      params.require(:article).permit(:title, :body)
    end

  end
end
