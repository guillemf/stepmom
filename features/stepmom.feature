Feature: We can list the steps contained in a file or folder 
	As a developer I want to keep a DRY and effective list of step definitions
	ensuring I don't have repeated tests or too similar ones.

  @list_process
  Scenario: List current folder
	Given a file named "~/Tmp/test_steps.rb" exists
	When I run `stepmom -p ~/Tmp/test_steps.rb list`
	Then the stdout should contain:
	"""
	Given	I am on a page with betting options
	When	I select a bet
	Then	I cant see the bet
	"""
	
  Scenario: List current folder sorted ascending
  	Given a file named "~/Tmp/test_steps.rb" exists
  	When I run `stepmom -p ~/Tmp/test_steps.rb list -s ASC`
  	Then the stdout should contain:
  	"""
  	Given	I am on a page with betting options
	Then	I cant see the bet
  	When	I select a bet
  	"""
	
  Scenario: List current folder sorted descending
	Given a file named "~/Tmp/test_steps.rb" exists
	When I run `stepmom -p ~/Tmp/test_steps.rb list -s DESC`
	Then the stdout should contain:
	"""
	When	I select a bet
	Then	I cant see the bet
	Given	I am on a page with betting options
	"""