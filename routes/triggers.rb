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

		tr_num = ''
		i = 0
		tr.trigger.each_line { |l|
			i += 1
			tr_num << "/* #{i} */ " << l
		}

		haml :trigger, :locals => {
			:activetab => :view,
			:title => 'Trigger',
			:hostname => hostname,
			:code => tr_num,
		}
	end
end
