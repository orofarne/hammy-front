class HammyFront < Sinatra::Base
	get '/generators' do
		genlist = []
		Generator.find_each { |gen|
			genlist << gen.name
		}

		haml :generators, :locals => {
			:activetab => :config,
			:title => 'Generators',
			:genlist => genlist,
		}
	end

	get '/generators/create' do
		haml :generators_edit, :locals => {
			:activetab => :config,
			:title => 'Create generator',
			:generatorname => '',
			:tag => '',
			:regexp => '',
			:code_json => JSON.dump({:mapcode => '', :reducecode => ''}),
		}
	end

	get '/generators/edit' do
		generatorname = params[:generatorname]
		halt 400 if not generatorname or generatorname.empty?

		g = Generator.find_by_name(generatorname) or halt 404
		tagname = ''
		tagname = g.tag.name if g.tag

		haml :generators_edit, :locals => {
			:activetab => :config,
			:title => 'Create generator',
			:generatorname => g.name,
			:tag => tagname,
			:regexp => g.regexp,
			:code_json => JSON.dump({
				:mapcode => g.mapcode,
				:reducecode => g.reducecode,
			}),
		}
	end

	post '/generators/save' do
		newgenerator = params[:newgenerator].to_i > 0
		generatorname = params[:generatorname]
		tagname = params[:tag]
		regexp = params[:regexp]
		code_json = params[:code]
		code = JSON.parse(code_json)

		ActiveRecord::Base.transaction do
			t = Tag.find_by_name tagname
			if newgenerator then
				g = Generator.create :name => generatorname, :mapcode => code['mapcode'], :reducecode => code['reducecode']
				g.tag = t if t
				g.regexp = regexp unless !regexp or regexp.empty?
				g.save
			else
				g = Generator.find_by_name(generatorname) or halt 404
				g.tag = t
				g.regexp = nil
				g.regexp = regexp unless !regexp or regexp.empty?
				g.mapcode = code['mapcode']
				g.reducecode = code['reducecode']
				g.save
			end
		end

		haml :done, :locals => {
			:activetab => nil,
			:title => 'Done',
		}
	end
end