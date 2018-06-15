require 'coveralls'
Coveralls.wear_merged!('rails')

require 'cucumber/rails'
require 'elasticsearch/extensions/test/cluster'

ActionController::Base.allow_rescue = false

begin
  DatabaseCleaner.strategy = :transaction
rescue NameError
  raise "You need to add database_cleaner to your Gemfile (in the :test group) if you wish to use it."
end

Chromedriver.set_version('2.36')

Capybara.register_driver(:selenium) do |app|
  options = Selenium::WebDriver::Chrome::Options.new(
      args: %w(  no-sandbox disable-popup-blocking disable-infobars headless)
  )
  Capybara::Selenium::Driver.new(app, browser: :chrome, options: options)
end

Cucumber::Rails::Database.javascript_strategy = :truncation
Capybara.javascript_driver = :selenium

World(FactoryBot::Syntax::Methods)

Before do
  OmniAuth.config.test_mode = true
  OmniAuth.config.mock_auth[:facebook] = OmniAuth::AuthHash.new(OmniAuthFixtures.facebook_response)
  RecipesIndex.create! unless RecipesIndex.exists?
end

if !ENV['CHEWY']
  Before do
    Chewy.strategy(:bypass)
    Elasticsearch::Extensions::Test::Cluster.start(
      port: 9250,
      nodes: 1,
      timeout: 120
    ) unless Elasticsearch::Extensions::Test::Cluster.running?(on: 9250)
  end
end

  After do
    Elasticsearch::Extensions::Test::Cluster.stop(port: 9250)
  end

After do
  RecipesIndex.delete! if RecipesIndex.exists?
end
