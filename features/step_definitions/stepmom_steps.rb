When /^I get help for "([^"]*)"$/ do |app_name|
  @app_name = app_name
  step %(I run `#{app_name} help`)
end

# Add more step definitions here
Given(/^a file named "([^"]*)" exists$/) do |filepath|
  File.exists?(File.expand_path(filepath))
end
