class HammyFront < Sinatra::Base
	get '/charts' do
		haml :chart_selector, :locals => {
			:activetab => :view,
			:title => 'Charts',
		}
	end

	get '/charts/show' do
		hostname = params[:hostname]
		itemkey = params[:itemkey]
		period = params[:period].to_i

		haml :chart, :locals => {
			:activetab => :view,
			:title => 'Chart',
			:hostname => hostname,
			:itemkey => itemkey,
			:period => period,
			:dataurl => '/data/values',
			:avgline => (period > 3600),
		}
	end
end
