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

	get '/tags/create' do
		haml :tags_edit, :locals => {
			:activetab => :config,
			:title => 'Create tag',
			:tagname => '',
			:code_json => JSON.dump({:code => ''}),
		}
	end

	get '/tags/edit' do
		tagname = params[:tagname]
		halt 400 if !tagname || tagname.empty?

		tag = Tag.find_by_name(tagname) or halt 404

		haml :tags_edit, :locals => {
			:activetab => :config,
			:title => tagname,
			:tagname => tagname,
			:code_json => JSON.dump({:code => tag.triggercode.to_s}),
		}
	end

	post '/tags/save' do
		newtag = params[:newtag].to_i > 0
		tagname = params[:tagname]
		code_json = params[:code]
		code = JSON.parse(code_json)['code']

		ActiveRecord::Base.transaction do
			if newtag then
				Tag.create! :name => tagname, :triggercode => code
			else
				t = Tag.find_by_name tagname
				t.triggercode = code
				t.save
			end
		end

		haml :done, :locals => {
			:activetab => nil,
			:title => 'Done',
		}
	end
end
