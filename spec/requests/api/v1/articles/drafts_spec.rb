require 'rails_helper'

RSpec.describe "Api::V1::Articles::Drafts", type: :request do
  describe "GET /index" do
    # context ""
    subject { get(api_v1_articles_drafts_path) }

    let!(:article1) { create(:article, :draft, updated_at: 1.days.ago) }
    let!(:article2) { create(:article, :draft, updated_at: 2.days.ago) }
    let!(:article3) { create(:article, :draft) }

    before { create(:article, :published) }
    it "下書き記事のみ取得ができる" do
      subject
      res = JSON.parse(response.body)

      expect(response).to have_http_status(:ok)
      expect(res.length).to eq 3
      expect(res.map {|d| d["id"] }).to eq [article3.id, article1.id, article2.id]
      expect(res[0].keys).to eq ["id", "title", "updated_at", "user"]
      expect(res[0]["user"].keys).to eq ["id", "name", "email"]
    end

    describe "GET /articles/:id" do
      subject { get(api_v1_articles_draft_path(article_id)) }

      context "指定した id の記事が存在して" do
        let(:article_id) { article.id }

        context "対象の記事が下書き状態であるとき" do
          let(:article) { create(:article, :draft) }

          it "任意の記事が取得できる" do
            subject
            res = JSON.parse(response.body)

            expect(response).to have_http_status(:ok)
            expect(res["id"]).to eq article.id
            expect(res["title"]).to eq article.title
            expect(res["body"]).to eq article.body
            expect(res["updated_at"]).to be_present
            expect(res["user"]["id"]).to eq article.user.id
            expect(res["user"].keys).to eq ["id", "name", "email"]
          end
        end

        context "対象の記事が公開状態であるとき" do
          let(:article) { create(:article, :published) }

          it "記事が見つからない" do
            expect { subject }.to raise_error ActiveRecord::RecordNotFound
          end
        end
      end

      context "指定した id の記事が存在しない場合" do
        let(:article_id) { 10000 }

        it "記事が見つからない" do
          expect { subject }.to raise_error ActiveRecord::RecordNotFound
        end
      end
    end
  end
end
