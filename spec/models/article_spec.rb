# == Schema Information
#
# Table name: articles
#
#  id         :bigint           not null, primary key
#  body       :text
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


  #pending "add some examples to (or delete) #{__FILE__}"
end
