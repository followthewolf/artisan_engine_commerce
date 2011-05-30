require 'database_cleaner'

RSpec.configure do |config|
  config.before :suite do
    DatabaseCleaner.strategy = :transaction
    DatabaseCleaner.clean_with :truncation
  end

  config.before :each do
    Capybara.reset_sessions!
    
    if example.metadata[ :js ]
      Capybara.current_driver   = :selenium
      DatabaseCleaner.strategy  = :truncation
    else
      DatabaseCleaner.strategy = :transaction
      DatabaseCleaner.start
    end
  end

  config.after :each do
    Capybara.use_default_driver if example.metadata[ :js ]
    DatabaseCleaner.clean
  end
end