class AddArticleIdToMultipleTables < ActiveRecord::Migration[6.1]
  def change
    add_reference :article_likes, :article, foreign_key: true
    add_reference :comments, :article, foreign_key: true
  end
end
