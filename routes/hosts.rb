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
			:hostmap => hostmap,
		}
	end

	get '/hosts/create' do
		haml :hosts_edit, :locals => {
			:activetab => :config,
			:title => 'Create host',
			:hostname => '',
			:tags => '',
			:code_json => JSON.dump({:code => ''}),
		}
	end

	get '/hosts/edit' do
		hostname = params[:hostname]
		halt 400 if not hostname or hostname.empty?

		host = Host.find_by_name(hostname) or halt 404

		tags = []
		host.tags.each { |tag|
			tags << tag.name
		}

		haml :hosts_edit, :locals => {
			:activetab => :config,
			:title => hostname,
			:hostname => hostname,
			:tags => tags.join(', '),
			:code_json => JSON.dump({:code => host.triggercode.to_s}),
		}
	end

	post '/hosts/save' do
		newhost = params[:newhost].to_i > 0
		hostname = params[:hostname]
		tags_str = params[:tags]
		code_json = params[:code]
		code = JSON.parse(code_json)['code']
		tags = tags_str.split ','
		tags.map! { |t| t.strip }

		ActiveRecord::Base.transaction do
			h = nil
			if newhost then
				h = Host.create! :name => hostname, :triggercode => code
			else
				h = Host.find_by_name hostname
				Hoststag.delete_all ["host_id = ?", h.id]
				h.triggercode = code
				h.save
			end
			Tag.where(:name => tags).each { |tag|
				Hoststag.create! :host_id => h.id, :tag_id => tag.id
			}
		end

		haml :done, :locals => {
			:activetab => nil,
			:title => 'Done' + code,
		}
	end
end