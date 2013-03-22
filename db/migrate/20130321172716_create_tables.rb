class CreateTables < ActiveRecord::Migration
	def up
		# hosts (Monitoring OBJECTS)
		create_table :hosts do |t|
			t.string :name, :null => false
			t.text :triggercode
		end
		add_index :hosts, :name, :unique => true

		# tags
		create_table :tags do |t|
			t.string :name, :null => false
			t.text :triggercode
		end
		add_index :tags, :name, :unique => true

		# hoststags
		create_table :hoststags do |t|
			t.integer :host_id, :null => false
			t.integer :tag_id, :null => false
		end
	end

	def down
		drop_table :hosts
		drop_table :tags
		drop_table :hoststags
	end
end
