#!/usr/bin/env ruby

require 'active_record'
require 'yaml'
require 'logger'

require_relative '../models/models.rb'
require_relative '../models/trigger.rb'

dbconfig = YAML::load(File.open(File.join(File.dirname(__FILE__), '..', 'config', 'database.yml')))

ActiveRecord::Base.logger = Logger.new(STDERR)
ActiveRecord::Base.establish_connection(dbconfig)

def format_trigger_code(code)
	trigger = "begin\n"
	code.each_line { |l|
		if l.ends_with? "\n" then
			trigger << "\t#{l}"
		else
			trigger << "\t#{l}\n"
		end
	}
	trigger << "end\n\n"
	return trigger
end

ActiveRecord::Base.transaction do
	Trigger.delete_all

	Host.includes(:tags).find_each { |host|
		trigger = ""
		host.tags.each { |tag|
			if tag.triggercode and not tag.triggercode.empty? then
				trigger << format_trigger_code(tag.triggercode)
			end
			trigger << format_trigger_code(host.triggercode) if host.triggercode
		}

		Trigger.create! :obj_key => host.name, :obj_trigger => trigger unless trigger.empty?
	}

	Generator.find_each { |gen|
		sqlq = 'SELECT name FROM hosts h'
		where_sql = ''
		sql_args = []
		if gen.tag then
			sqlq << ' JOIN hoststags ht ON h.id = ht.host_id'
			where_sql << ' ht.tag_id = ?'
			sql_args << gen.tag.id
		end
		if gen.regexp and not gen.regexp.empty? then
			where_sql << ' AND' unless where_sql.empty?
			where_sql << ' h.name REGEXP ?'
			sql_args << "^#{gen.regexp}$"
		end
		sqlq << ' WHERE' << where_sql if not where_sql.empty?

		found = false
		Host.find_by_sql([sqlq, *sql_args]).each { |h|
			trigger = format_trigger_code(gen.mapcode)
			t = Trigger.find_by_obj_key(h.name) or Trigger.create(:obj_key => h.name)
			t.obj_trigger = '' unless t.obj_trigger
			t.obj_trigger << trigger
			t.save
			found = true
		}

		if found then
			trigger = format_trigger_code(gen.reducecode)
			t = Trigger.find_by_obj_key(gen.host.name) or Trigger.create(:obj_key => gen.host.name)
			t.obj_trigger = '' unless t.obj_trigger
			t.obj_trigger << trigger
			t.save
		end
	}
end