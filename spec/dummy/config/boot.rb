# ---------- Set up gems from the parent gem's Gemfile. ---------- #

require 'rubygems'
gemfile = File.expand_path( '../../../../Gemfile', __FILE__ )

if File.exist?( gemfile )
  ENV[ 'BUNDLE_GEMFILE' ] = gemfile
  require 'bundler'
  Bundler.setup
end

# ----- Add the parent gem's lib path to Ruby's load paths. ------ #

$:.unshift File.expand_path( '../../../../lib', __FILE__ )