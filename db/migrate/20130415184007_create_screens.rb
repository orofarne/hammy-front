class CreateScreens < ActiveRecord::Migration
	def up
		# screens
		create_table :screens do |t|
			t.string :name, :null => false
			t.string :slug, :null => false
			t.text :attrs, :limit => 2**16+1
			t.text :content, :limit => 2**16+1
		end
		add_index :screens, :slug, :unique => true
	end

	def down
		drop_table :screens
	end
end
