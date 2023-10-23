# == Schema Information
#
# Table name: articles
#
#  id         :bigint           not null, primary key
#  body       :text
#  status     :string           default("draft")
#  title      :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  user_id    :bigint           not null
#
# Indexes
#
#  index_articles_on_user_id  (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (user_id => users.id)
#
require 'rails_helper'

RSpec.describe Article, type: :model do
  context "title を指定しているとき" do
    it "articleが作られる" do
      article = create(:article)
      expect(article.valid?).to eq true
    end
  end


  context "title を指定していないとき" do
    it "articleが作られない " do
      article = build(:article,title: nil)
      expect(article).to be_invalid
      expect(article.errors.details[:title][0][:error]).to eq :blank
    end
  end

  describe "正常系" do
    context "タイトルと本文が入力されているとき" do
      let(:article) { build(:article) }

      it "下書き状態の記事が作成できる" do
        expect(article).to be_valid
        expect(article.status).to eq "draft"
      end
    end

    context "status が下書き状態のとき" do
      let(:article) { build(:article, :draft) }
      it "記事を下書き状態で作成できる" do
        expect(article).to be_valid
        expect(article.status).to eq "draft"
      end
    end

    context "status が公開状態のとき" do
      let(:article) { build(:article, :published) }
      it "記事を公開状態で作成できる" do
        expect(article).to be_valid
        expect(article.status).to eq "published"
      end
    end
  end

  #pending "add some examples to (or delete) #{__FILE__}"
end
