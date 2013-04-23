module Crimagify

	require 'rubygems'
	require 'rmagick'
	require 'carrierwave'

	class Engine < ::Rails::Engine
		isolate_namespace Crimagify

		config.generators.load_generators

		initializer 'crimagify.action_controller' do |app|
			ActiveSupport.on_load :action_controller do
				helper Crimagify::ApplicationHelper
			end
		end

	end
end
