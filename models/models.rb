class Host < ActiveRecord::Base
	attr_accessible :name, :triggercode

	has_many :hoststags
	has_many :tags, :through => :hoststags
end

class Tag < ActiveRecord::Base
	attr_accessible :name, :triggercode

	has_many :hoststags
	has_many :hosts, :through => :hoststags
end

class Hoststag < ActiveRecord::Base
	belongs_to :host
	belongs_to :tag
end