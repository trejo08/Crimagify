module Crimagify
	module Generators
		class GenerateSchemaGenerator < ::Rails::Generators::Base

			source_root File.expand_path("../templates", __FILE__)
			argument :class_name, :type => :string, :default => "User"
			desc "Install Crimagify"
			
			def read_table_fields
				class_name_cte = class_name.constantize
				has_column = class_name_cte.columns.collect{|c|c.name}.include?("crimagify_schema")

				if !has_column
					puts "generating migration for #{class_name}"
					generate "migration add_field_crimagify_schema_to_#{class_name_cte.class.table_name} crimagify_schema:string"
				else
					puts "#{class_name} contains field crimagify_schema"
				end
			end

		end
	end
end