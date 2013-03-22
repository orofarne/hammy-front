class Mobject < ActiveRecord::Base
	attr_accessible :name, :triggercode

	has_many :mobjectstags
	has_many :tags, :through => :mobjectstags
end

class Tag < ActiveRecord::Base
	attr_accessible :name, :triggercode

	has_many :mobjectstags
	has_many :mobjects, :through => :mobjectstags
end

class Mobjectstag < ActiveRecord::Base
	belongs_to :mobject
	belongs_to :tag
end