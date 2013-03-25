class HammyFront < Sinatra::Base
	get '/data/:opt' do |opt|
		halt 404 unless ['values', 'state'].include?(opt)

		require 'open-uri'
		url = 'http://localhost:4001/data/' + opt
		unless params.empty? then
			first = true
			params.each { |k, v|
				if k != 'opt' and v.instance_of? String then
					url << (first ? '?' : '&')
					first = false
					url << URI::encode(k) << '=' << URI::encode(v)
				end
			}
		end
		open(url).read
	end
end