Feature: We can search and filter steps based on different criteria
	As a developer I want to keep a DRY and effective list of step definitions
	ensuring I don't have repeated tests or too similar ones.

  Scenario: Search without params
	Given a file named "~/Tmp/test_steps.rb" exists
	When I run `stepmom -p ~/Tmp/test_steps.rb search`
	Then the stderr should contain "error: Please select one of the valid options"
	
	
  Scenario: Search without param value regex
  	Given a file named "~/Tmp/test_steps.rb" exists
  	When I run `stepmom -p ~/Tmp/test_steps.rb search -r`
  	Then the stderr should contain "error: missing argument: -r"
	
  Scenario: Search without param value description
  	Given a file named "~/Tmp/test_steps.rb" exists
  	When I run `stepmom -p ~/Tmp/test_steps.rb search -d`
  	Then the stderr should contain "error: missing argument: -d"
	
  Scenario: Search with unmatching param value description
  	Given a file named "~/Tmp/test_steps.rb" exists
  	When I run `stepmom -p ~/Tmp/test_steps.rb search -d "Test"`
  	Then the stdout should contain:
  	"""
  	14: 	test_steps.rb       	I select a bet
  	18: 	test_steps.rb       	I cant see the bet
  	20: 	test_steps.rb       	I am (.*)? on the Homepage
  	35: 	test_steps.rb       	I am on a page with betting options
  	37: 	test_steps.rb       	I log in with username: (.+) and password: (.+)
  	"""

  Scenario: Search with matching param value description
  	Given a file named "~/Tmp/test_steps.rb" exists
  	When I run `stepmom -p ~/Tmp/test_steps.rb search -d "When(/^I cant see the bet$/) do"`
  	Then the stdout should contain:
  	"""
	0: 	test_steps.rb       	I cant see the bet
  	"""

  Scenario: Search with matching param value regex
  	Given a file named "~/Tmp/test_steps.rb" exists
  	When I run `stepmom -p ~/Tmp/test_steps.rb search -r "with"`
  	Then the stdout should contain:
  	"""
  	test_steps.rb       	I am on a page with betting options
  	test_steps.rb       	I log in with username: (.+) and password: (.+)
  	"""

  Scenario: Search with no matching param value regex
  	Given a file named "~/Tmp/test_steps.rb" exists
  	When I run `stepmom -p ~/Tmp/test_steps.rb search -r "abcd"`
  	Then the stderr should contain "error: Results is empty"
