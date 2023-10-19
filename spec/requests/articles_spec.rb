require 'rails_helper'

RSpec.describe "articles", type: :request do
  describe "GET /api_v1_articles" do
    # binding.pry
    subject { get(api_v1_articles_path) }
    before { create_list(:article, 3) }
    it "記事の一覧が取得できる" do
      subject
      res = JSON.parse(response.body)
      expect(res.length).to eq 3
      expect(res[0].keys).to eq ["id", "title"]
      expect(response).to have_http_status(200)
    end
  end

  describe "GET /api_v1_articles/:id" do
    # 中略

    subject { get(api_v1_article_path(article_id)) }

    context "指定した id の記事が存在するとき" do
      let(:article) { create(:article) }
      let(:article_id) { article.id }
      it "その記事のレコードが取得できる" do
        subject
        res = JSON.parse(response.body)
        expect(response).to have_http_status(200)
        expect(res["title"]).to eq article.title
        expect(res["body"]).to eq article.body
      end
    end

    context "指定した id の記事が存在しないとき" do
      let(:article_id) { 10000 }
      it "記事が見つからない" do
        expect { subject }.to raise_error ActiveRecord::RecordNotFound
      end
    end
  end


  describe "POST /articles" do
    subject { post(api_v1_articles_path, params: params, headers: headers) }

    let(:params) { { article: attributes_for(:article) } }
    let(:current_user) { create(:user) }

    # stub
    let(:headers) { current_user.create_new_auth_token }

    it "記事のレコードが作成できる" do
      expect { subject }.to change { Article.where(user_id: current_user.id).count }.by(1)
      res = JSON.parse(response.body)
      expect(res["title"]).to eq params[:article][:title]
      expect(res["body"]).to eq params[:article][:body]
      expect(response).to have_http_status(:ok)
    end
  end
  describe "PATCH /api/v1/articles/:id" do
    subject { patch(api_v1_article_path(article.id), params: params, headers: headers) }

    let(:params) { { article: attributes_for(:article) } }
    let(:current_user) { create(:user) }
    let(:headers) { current_user.create_new_auth_token }

    context "自分が所持している記事のレコードを更新しようとするとき" do
      let(:article) { create(:article, user: current_user) }

      it "記事を更新できる" do
        expect { subject }.to change { article.reload.title }.from(article.title).to(params[:article][:title]) &
                              change { article.reload.body }.from(article.body).to(params[:article][:body])
        expect(response).to have_http_status(:ok)
      end
    end

    context "自分が所持していない記事のレコードを更新しようとするとき" do
      let(:other_user) { create(:user) }
      let!(:article) { create(:article, user: other_user) }

      it "更新できない" do
        expect { subject }.to raise_error(ActiveRecord::RecordNotFound)
      end
    end
  end

  describe "DELETE /api/v1/articles/:id" do
    # binding.pry
    subject { delete(api_v1_article_path(article_id), headers: headers) }
    let(:article) { create(:article) }
    let!(:article_id) { article.id }
    let(:current_user) { create(:user) }
    let(:headers) { current_user.create_new_auth_token }

    it "任意のユーザーのレコードを削除できる" do
      expect { subject }.to change { Article.count }.by(-1)
    end
  end
end
