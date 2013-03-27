class HammyFront < Sinatra::Base
	get '/triggers' do
		haml :trigger_selector, :locals => {
			:activetab => :view,
			:title => 'Triggers',
		}
	end

	get '/triggers/show' do
		hostname = params[:hostname]

		tr = Trigger.find_by_host(hostname) or halt 404

		haml :trigger, :locals => {
			:activetab => :view,
			:title => 'Trigger',
			:hostname => hostname,
			:code => tr.trigger,
		}
	end
end