require 'rails/generators/active_record'

module ArtisanEngine
  module Generators
    module Commerce
      class UpdateGenerator < ActiveRecord::Generators::Base
  
        argument    :name, :default => 'commerce'
        source_root File.expand_path( '../templates', __FILE__ )
  
        def copy_update_migrations
          migration_template 'migrations/add_shipping_method_to_fulfillments.rb',
                             'db/migrate/add_shipping_method_to_fulfillments.rb'
        end
      end
    end
  end
end