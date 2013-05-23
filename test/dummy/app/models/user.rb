class User < ActiveRecord::Base

	has_many :products

  attr_accessible :email, :lastname, :name
  attr_accessible :products_attributes

  accepts_nested_attributes_for :products, allow_destroy: true
end
