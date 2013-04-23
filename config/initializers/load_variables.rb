if File.exists?("#{Rails.root}/config/crimagify_versions.yml")
	yml = YAML.load_file("#{Rails.root}/config/crimagify_versions.yml")
	CRIMAGIFY_ENV = yml
	CRIMAGIFY_ENV.freeze	
end
