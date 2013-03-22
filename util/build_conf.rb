#!/usr/bin/env ruby

require 'active_record'
require 'yaml'
require 'logger'

require_relative '../models/models.rb'
require_relative '../models/trigger.rb'

dbconfig = YAML::load(File.open(File.join(File.dirname(__FILE__), '..', 'config', 'database.yml')))

ActiveRecord::Base.logger = Logger.new(STDERR)
ActiveRecord::Base.establish_connection(dbconfig)

ActiveRecord::Base.transaction do
	Trigger.delete_all

	Host.includes(:tags).find_each { |host|
		trigger = ""
		host.tags.each { |tag|
			if tag.triggercode and not tag.triggercode.empty? then
				trigger << "begin\n"
				tag.triggercode.each_line { |l|
					if l.ends_with? "\n" then
						trigger << "\t#{l}"
					else
						trigger << "\t#{l}\n"
					end
				}
				trigger << "end\n\n"
			end
			trigger << host.triggercode if host.triggercode

			Trigger.create! :obj_key => host.name, :obj_trigger => trigger unless trigger.empty?
		}
	}
end