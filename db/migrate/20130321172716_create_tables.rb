class CreateTables < ActiveRecord::Migration
	def up
		# hosts (Monitoring objects)
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
		add_index :hoststags, [:host_id, :tag_id], :unique => true

		# generators
		create_table :generators do |t|
			t.string :name, :null => false
			t.integer :host_id
			t.integer :tag_id
			t.string :regexp
			t.text :mapcode
			t.text :reducecode
		end
		add_index :generators, :name, :unique => true

		# builded triggers (by hosts)
		create_table :triggers do |t|
			t.string :host, :null => false
			t.text :trigger
			t.timestamps
		end
		add_index :triggers, :host, :unique => true
	end

	def down
		drop_table :hosts
		drop_table :tags
		drop_table :hoststags
	end
end
