class HammyFront < Sinatra::Base
	get '/tags' do
		tagmap = {}

		Tag.includes(:hosts).find_each { |tag|
			hosts = []
			tag.hosts.each { |host|
				hosts << host.name
			}
			tagmap[tag.name] = hosts
		}

		haml :tags, :locals => {
			:activetab => :config,
			:title => 'Tags',
			:tagmap => tagmap
		}
	end
end