class User < ActiveRecord::Base
	attr_accessor :username, :email
	has_many :articles
	has_many :articles
end
