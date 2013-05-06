module Crimagify
	module Generators
		class InstallGenerator < ::Rails::Generators::Base
			source_root File.expand_path("../templates", __FILE__)
			desc "Install Crimagify"

			def copy_config_file
				copy_file "crimagify_versions.yml", "config/crimagify_versions.yml"
				copy_file "crimagify_settings.yml", "config/crimagify_settings.yml"
				copy_file "cropper.css.scss", "app/assets/stylesheets/cropper.css.scss"
				copy_file "jquery.Jcrop.css", "app/assets/stylesheets/jquery.Jcrop.css"
				copy_file "mixin.css.scss", "app/assets/stylesheets/mixin.css.scss"
			end

			def copy_migrations
				rake "crimagify:install:migrations"
			end
		end
	end
end