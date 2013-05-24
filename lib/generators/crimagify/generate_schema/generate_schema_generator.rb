module Crimagify
	module Generators
		class GenerateSchemaGenerator < ::Rails::Generators::Base

			source_root File.expand_path("../templates", __FILE__)
			argument :table_name, :type => :string, :default => "User"
			desc "Install Crimagify"
			
			def read_table_fields
				puts "llama bien al generador"
				puts "se genera bien la migracion a esta tabla #{table_name}"
				class_name = table_name.capitalize.constantize
				columns = class_name.columns.collect{|c|c.name}.include?("crimagify_schema")

				if !columns
					puts "generating migration for #{table_name}"
					generate "migration add_field_crimagify_schema_to_#{table_name} crimagify_schema:string"
				else
					puts "#{table_name} contain field crimagify_schema"
				end
			end

		end
	end
end