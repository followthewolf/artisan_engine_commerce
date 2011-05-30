Barista.configure do |c|
  # Compile CoffeeScripts into the ArtisanEngine gem's javascript repository.
  c.output_root = Pathname.new "#{ ArtisanEngine.root }/lib/generators/artisan_engine/templates/assets/javascripts/artisan_engine/commerce"
end