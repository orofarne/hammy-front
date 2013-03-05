#!/usr/bin/env ruby

require 'sinatra'
require 'couchbase'

cb = Couchbase.connect(:bucket => "config", :hostname => "localhost")

set :haml, :format => :html5

get '/' do
	haml :index
end

get '/trigger/:key' do |key|
    code = ""
    begin
        code = cb.get(key)
    rescue Couchbase::Error::NotFound
    end
    haml :editor, :locals => {:key => key, :code => code}
end

post '/save_trigger' do
    res = cb.set(params[:key], params[:code])
    "Saved! #{res}"
end
