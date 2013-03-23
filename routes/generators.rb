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
end