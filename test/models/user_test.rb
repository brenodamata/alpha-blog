require 'test_helper'

class UserTest < ActiveSupport::TestCase

	def setup
		@user = User.new(email: 't@b.c', username: 'tester', password: "123123")
	end

	test 'user should be valid' do
		assert @user
	end

	test 'user should have a username' do
		@user.username = " "
		assert_not @user.valid?
	end

	test 'username should be unique' do 
		@user.save
		new_user = User.new(email: 't1@b.c', username: 'tester', password: "123123")
		assert_not new_user.valid?
	end

	test 'username uniqueness should not be case sensitive' do
		@user.save
		new_user = User.new(email: 't2@b.c', username: 'TesTer', password: "123123")
		assert_not new_user.valid?
	end

	test 'username should not be too long' do
		@user.username = "a" * 26
		assert_not @user.valid?
	end

	test 'username should not be too short' do
		@user.username = "aa"
		assert_not @user.valid?
	end

	test 'user should have an email' do
		@user.email = " "
		assert_not @user.valid?
	end

	test 'email should be unique' do 
		@user.save
		new_user = User.new(email: 't@b.c', username: 'other', password: "123123")
		assert_not new_user.valid?
	end

	test 'email uniqueness should not be case sensitive' do
		@user.save
		new_user = User.new(email: 'T@b.c', username: 'TesTer', password: "123123")
		assert_not new_user.valid?
	end

	test 'email should not be too long' do
		@user.email = "a" * 102 + "@b.c"
		assert_not @user.valid?
	end

	test 'email should not be too short' do
		@user.email = "a@"
		assert_not @user.valid?
	end

	test 'email should have correct email format' do
		@user.email = "a@b"
		assert_not @user.valid?
	end


end
