class Comment < ActiveRecord::Base
	validates :user, presence: true
	validates :article, presence: true
	validates :description, presence: true

  belongs_to :user
  belongs_to :article
end
