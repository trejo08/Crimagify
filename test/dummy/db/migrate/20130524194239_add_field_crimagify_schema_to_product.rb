class AddFieldCrimagifySchemaToProduct < ActiveRecord::Migration
  def change
    add_column :products, :crimagify_schema, :string
  end
end
