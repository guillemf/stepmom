Feature: We can test which step definitions match a step
	As a developer I want to keep a DRY and effective list of step definitions
	ensuring I don't have repeated tests or too similar ones.
  
  Scenario: Test without params
	Given a file named "~/Tmp/test_steps.rb" exists
	When I run `stepmom -p ~/Tmp/test_steps.rb test`
	Then the stderr should contain "error: Invalid number of arguments"
	
	
  Scenario: Test with invalid param
	Given a file named "~/Tmp/test_steps.rb" exists
	When I run `stepmom -p ~/Tmp/test_steps.rb test adbc`
  	Then the stderr should contain "error: Invalid step definition"

  Scenario: Test with valid param one argument
	Given a file named "~/Tmp/test_steps.rb" exists
	When I run `stepmom -p ~/Tmp/test_steps.rb test "Given I am Sitting here on the Homepage"`
  	Then the stdout should contain:
	"""
	test_steps.rb       	I am (.*)? on the Homepage
	test_steps.rb       	I am (.*)? Homepage
	"""

  Scenario: Test with valid param two arguments
	Given a file named "~/Tmp/test_steps.rb" exists
	When I run `stepmom -p ~/Tmp/test_steps.rb test "Given I log in with username: myname and password: mypass"`
  	Then the stdout should contain:
	"""
	test_steps.rb       	I log in with username: (.+) and password: (.+)
	"""
	
