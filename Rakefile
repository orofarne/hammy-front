require "sinatra/activerecord/rake"
require "./app"

namespace :contrib do
	task :install_vis do
		repo = 'https://github.com/dmage/vis.git'
		Dir.chdir 'public'
		Dir.mkdir 'contrib' unless Dir.exists? 'contrib'
		Dir.chdir 'contrib'
		`git clone '#{repo}'`
		Dir.chdir 'vis'
		`make`
		Dir.chdir '../../..'
	end

	task :install_ace do
		repo = 'https://github.com/ajaxorg/ace-builds.git'
		Dir.chdir 'public'
		Dir.mkdir 'contrib' unless Dir.exists? 'contrib'
		Dir.chdir 'contrib'
		`git clone '#{repo}' 'ace'`
		Dir.chdir '../..'
	end

	task :install => [:install_ace,:install_vis]

	task :clean do
		`rm -rf 'public/contrib'`
	end
end