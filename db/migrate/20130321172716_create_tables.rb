class CreateTables < ActiveRecord::Migration
	def up
		# mobjects (Monitoring OBJECTS)
		create_table :mobjects do |t|
			t.string :name, :null => false
			t.text :triggercode
		end
		add_index :mobjects, :name, :unique => true

		# tags
		create_table :tags do |t|
			t.string :name, :null => false
			t.text :triggercode
		end
		add_index :tags, :name, :unique => true

		# mobjectstags
		create_table :mobjectstags do |t|
			t.integer :mobject_id, :null => false
			t.integer :tag_id, :null => false
		end
	end

	def down
		drop_table :mobjects
		drop_table :tags
		drop_table :mobjectstags
	end
end
