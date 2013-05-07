module Crimagify

	require 'rubygems'
	require 'RMagick'
	require 'carrierwave'

	class Engine < ::Rails::Engine
		isolate_namespace Crimagify

		config.generators.load_generators

		config.before_configuration do
			config_setting_app = File.join(Rails.root, 'config', 'crimagify_settings.yml')
			puts config_setting_app
			YAML.load(File.open(config_setting_app)).each do |key, value|
				ENV[key.to_s] = value.to_s
			end if File.exists?(config_setting_app)
		end

		initializer 'crimagify.action_controller' do |app|
			ActiveSupport.on_load :action_controller do
				helper Crimagify::ApplicationHelper
			end
		end

	end
end