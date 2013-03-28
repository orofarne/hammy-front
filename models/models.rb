class Host < ActiveRecord::Base
	attr_accessible :name, :triggercode

	validates_length_of :name, :minimum => 2, :maximum => 255
	validates_format_of :name, :with => /^[0-9A-Za-z_][0-9A-Za-z\-_\.]*[0-9A-Za-z_]$/

	has_many :hoststags
	has_many :tags, :through => :hoststags
	has_many :generators
end

class Tag < ActiveRecord::Base
	attr_accessible :name, :triggercode

	validates_length_of :name, :minimum => 2, :maximum => 255
	validates_format_of :name, :with => /^[0-9A-Za-z_][0-9A-Za-z\-_\. ]*[0-9A-Za-z_]$/

	has_many :hoststags
	has_many :hosts, :through => :hoststags
	has_many :generator
end

class Hoststag < ActiveRecord::Base
	belongs_to :host
	belongs_to :tag
end

class Generator < ActiveRecord::Base
	attr_accessible :name, :regexp, :mapcode, :reducecode

	validates_length_of :name, :minimum => 2, :maximum => 255
	validates_format_of :name, :with => /^[0-9A-Za-z_][0-9A-Za-z\-_\. ]*[0-9A-Za-z_]$/
	validates_length_of :regexp, :minimum => 2, :maximum => 255

	belongs_to :tag
	belongs_to :host
end

class Trigger < ActiveRecord::Base
	attr_accessible :host, :trigger

	validates_length_of :host, :minimum => 2, :maximum => 255
	validates_format_of :host, :with => /^[0-9A-Za-z_][0-9A-Za-z\-_\.]*[0-9A-Za-z_]$/
end
