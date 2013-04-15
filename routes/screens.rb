class HammyFront < Sinatra::Base
	get '/screens' do
		screenlist = []
		Screen.find_each { |s|
			screenlist << {
				:slug => s.slug,
				:name => s.name,
			}
		}

		haml :screens, :locals => {
			:activetab => :config,
			:title => 'Screens',
			:screenlist => screenlist,
		}
	end

	get '/screens/create' do
		haml :screens_edit, :locals => {
			:activetab => :config,
			:title => 'Create screen',
			:name => '',
			:slug => '',
			:attrs_json => JSON.dump({}),
			:content_json => JSON.dump([]),
		}
	end

	get '/screens/edit' do
		slug = params[:slug]
		halt 400 if !slug || slug.empty?

		s = Screen.find_by_slug(slug) or halt 404

		haml :screens_edit, :locals => {
			:activetab => :config,
			:title => 'Create screen',
			:name => s.name,
			:slug => s.slug,
			:attrs_json => s.attrs,
			:content_json => s.content,
		}
	end

	post '/screens/save' do
		newscreen = params[:newscreen].to_i > 0
		name = params[:name]
		slug = params[:slug]
		attrs_json = params[:attrs]
		content_json = params[:content]
		attrs = JSON.parse(attrs_json)
		content = JSON.parse(content_json)

		ActiveRecord::Base.transaction do
			if newscreen then
				s = Screen.create :slug => slug, :name => name, :attrs => attrs_json, :content => content_json
				s.save
			else
				s = Screen.find_by_slug(slug) or halt 404
				s.name = name
				s.attrs = attrs_json
				s.content = content_json
				s.save
			end
		end

		haml :done, :locals => {
			:activetab => nil,
			:title => 'Done',
			:link => {
				:href => "/screens/show?slug=#{slug}",
				:text => name,
			}
		}
	end

	get '/screens/show' do
		slug = params[:slug]
		period = params[:period].to_i

		s = Screen.find_by_slug(slug) or halt 404

		haml :screen, :locals => {
			:activetab => :config,
			:title => "Screen :: #{s.name}",
			:name => s.name,
			:cfg => JSON.dump({
				:period => period,
				:dataurl => '/data/values',
			}),
			:attrs => s.attrs,
			:content => s.content,
		}
	end
end
