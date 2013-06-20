CRIMAGIFY_ENV = {}
env_file = File.join(Rails.root, 'config', 'billify.yml')
if File.exists?(env_file)
	yml = YAML.load_file(env_file)
	CRIMAGIFY_ENV = yml
	CRIMAGIFY_ENV.freeze
end
