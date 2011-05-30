require 'spec_helper'

describe ArtisanEngine::Commerce do
  it "is an Engine" do
    ArtisanEngine::Commerce::Engine.ancestors.should include Rails::Engine
  end
  
  context "includes stylesheet expansions: " do
    context "artisan_engine: " do
      it "artisan_engine/commerce/back.css" do
        ActionView::Helpers::AssetTagHelper.stylesheet_expansions[ :artisan_engine ]
        .should include "artisan_engine/commerce/back"
      end
    end
    
    context "artisan_engine_front: " do
      it "artisan_engine/commerce/front.css" do
        ActionView::Helpers::AssetTagHelper.stylesheet_expansions[ :artisan_engine_front ]
        .should include "artisan_engine/commerce/front"
      end
    end
  end
end

describe "ArtisanEngine::Commerce Test/Development Environment" do
  it "initializes ArtisanEngine::Commerce" do
    ArtisanEngine::Commerce.should be_a Module
  end
  
  it "compiles its stylesheets into ArtisanEngine's stylesheets/artisan_engine/commerce directory" do
    Compass.configuration.css_path.should == "#{ ArtisanEngine.root }/lib/generators/artisan_engine/templates/assets/stylesheets/artisan_engine/commerce"
  end
  
  it "does not compile stylesheets during tests" do
    Sass::Plugin.options[ :never_update ].should be_true
  end
  
  it "compiles its javascripts into ArtisanEngine's javascripts/artisan_engine/commerce directory" do
    Barista.output_root.should == Pathname.new( "#{ ArtisanEngine.root }/lib/generators/artisan_engine/templates/assets/javascripts/artisan_engine/commerce" )
  end
end