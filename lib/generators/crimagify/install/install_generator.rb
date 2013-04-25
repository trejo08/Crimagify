module Crimagify
	module Generators
		class InstallGenerator < ::Rails::Generators::Base
			source_root File.expand_path("../templates", __FILE__)
			desc "Install Crimagify"

			def copy_config_file
				copy_file "crimagify_versions.yml", "config/crimagify_versions.yml"
				copy_file "crimagify_settings.yml", "config/crimagify_sestings.yml"
			end

			def copy_migrations
				rake "crimagify:install:migrations"
			end
		end
	end
end