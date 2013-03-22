require 'sinatra/base'
require 'sinatra/activerecord'

require './models/models.rb'

class HammyFront < Sinatra::Base
	register Sinatra::ActiveRecordExtension

	configure :production, :development do
		set :database_file, 'config/database.yml'
		set :haml, :format => :html5
	end

	get '/' do
		haml :home, :locals => {:activetab => nil}
	end
end