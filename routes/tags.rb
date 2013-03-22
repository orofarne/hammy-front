class HammyFront < Sinatra::Base
	get '/tags' do
		tagmap = {}

		Tag.includes(:mobjects).find_each { |tag|
			mobjects = []
			tag.mobjects.each { |mobject|
				mobjects << mobject.name
			}
			tagmap[tag.name] = mobjects
		}

		haml :tags, :locals => {
			:activetab => :config,
			:tagmap => tagmap
		}
	end
end