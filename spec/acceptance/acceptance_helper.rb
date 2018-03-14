require 'rails_helper'
Capybara.javascript_driver = :webkit

RSpec.configure do |config|
  config.include AcceptanceHelper, type: :feature
end
