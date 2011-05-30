source 'http://rubygems.org'
gemspec

gem 'rake', '~> 0.8.7'

if ENV['BUNDLE_ENV'] == "dev"
	gem 'artisan_engine_core',				:path => '../core'
	gem 'artisan_engine_listability',	:path => '../listability'
	gem 'artisan_engine_attachability',	:path => '../attachability'
	gem 'artisan_engine_attachments',	:path => '../attachments'
	gem 'artisan_engine_catalog',			:path => '../catalog'
else
	gem 'artisan_engine_core',				:git => 'git@github.com:followthewolf/artisan_engine_core.git'
	gem 'artisan_engine_listability',	:git => 'git@github.com:followthewolf/artisan_engine_listability.git'
	gem 'artisan_engine_attachability',	:git => 'git@github.com:followthewolf/artisan_engine_attachability.git'
	gem 'artisan_engine_attachments',	:git => 'git@github.com:followthewolf/artisan_engine_attachments.git'
	gem 'artisan_engine_catalog',			:git => 'git@github.com:followthewolf/artisan_engine_catalog.git'
end