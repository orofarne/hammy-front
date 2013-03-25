class HammyFront < Sinatra::Base
	get '/states' do
		haml :state_selector, :locals => {
			:activetab => :view,
			:title => 'states',
		}
	end

	get '/states/show' do
		hostname = params[:hostname]

		haml :state, :locals => {
			:activetab => :view,
			:title => 'State',
			:hostname => hostname,
			:dataurl => '/data/state',
		}
	end
end