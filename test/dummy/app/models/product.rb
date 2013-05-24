class Product < ActiveRecord::Base
	include Crimagify::CrimagifyEnvs
	
	belongs_to :user
  attr_accessible :description, :name, :user_id, :crimagify_schema
end