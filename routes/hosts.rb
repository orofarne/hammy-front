class HammyFront < Sinatra::Base
	get '/hosts' do
		hostmap = {}

		Host.includes(:tags).find_each { |host|
			tags = []
			host.tags.each { |tag|
				tags << tag.name
			}
			hostmap[host.name] = tags
		}

		haml :hosts, :locals => {
			:activetab => :config,
			:title => 'Hosts',
			:hostmap => hostmap
		}
	end

	get '/hosts/create' do
		haml :hosts_edit, :locals => {
			:activetab => :config,
			:title => 'Create host',
		}
	end
end