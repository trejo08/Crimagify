module Crimagify
	module Generators
		class InstallGenerator < ::Rails::Generators::Base
			source_root File.expand_path("../templates", __FILE__)
			desc "Install Crimagify"

			def copy_config_file
				copy_file "crimagify_versions.yml", "config/crimagify_versions.yml"
			end

			def copy_migrations
				rake "crimagify:install:migrations"
				Crimagify::Engine.load_seed
			end
		end
	end
end