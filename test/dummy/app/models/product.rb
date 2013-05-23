class Product < ActiveRecord::Base
	include Crimagify::CrimagifyEnvs
	
	belongs_to :user
	# validates_presence_of :user
  attr_accessible :description, :name, :user_id
end