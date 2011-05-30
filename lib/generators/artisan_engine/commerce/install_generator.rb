require 'rails/generators/active_record'

module ArtisanEngine
  module Generators
    module Commerce
      class InstallGenerator < ActiveRecord::Generators::Base

        argument    :name, :default => 'commerce'
        source_root File.expand_path( '../templates', __FILE__ )
       
        def install_catalog
          Rails::Generators.invoke 'artisan_engine:catalog:install'
          sleep 1 # to prevent duplicate timestamps.
        end
       
        def copy_installation_migration
          migration_template 'migrations/install_commerce.rb', 
                             'db/migrate/install_commerce.rb'
        end
        
      end
    end
  end
end