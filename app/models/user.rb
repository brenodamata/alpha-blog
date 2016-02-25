class User < ActiveRecord::Base
	attr_accessable :username, :email
	has_many :articles
	has_many :comments
end
