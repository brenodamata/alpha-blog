require 'test_helper'

class ArticleTest < ActiveSupport::TestCase
  
	def setup
		@user = User.new(email: 'a@b.c', username: 'abc', password: "123123")
		@article = Article.new(title: "Test Article", 
													 description: "Article desc", 
													 user: @user)
	end


	test "article should be valid" do
		assert @article
	end

	test "article should have title" do
		@article.title = " "
		assert_not @article.valid?
	end

	test "article should have description" do
		@article.description = " "
		assert_not @article.valid?
	end

	test "article should belog to a user" do
		@article.user = nil
		assert_not @article.valid?
	end

end
