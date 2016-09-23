Feature: We can list the steps contained in a file or folder 
	As a developer I want to keep a DRY and effective list of step definitions
	ensuring I don't have repeated tests or too similar ones.

  @list_process
  Scenario: List current folder
	Given a file named "~/Tmp/test_steps.rb" exists
	When I run `stepmom -p ~/Tmp/test_steps.rb list`
	Then the stdout should contain:
	"""
	I am on a page with betting options
	I select a bet
	I cant see the bet
	I am (.*)? on the Homepage
	I log in with username: (.+) and password: (.+)
	"""
	
  Scenario: List current folder sorted ascending
  	Given a file named "~/Tmp/test_steps.rb" exists
  	When I run `stepmom -p ~/Tmp/test_steps.rb list -s ASC`
  	Then the stdout should contain:
  	"""
	I am (.*)? on the Homepage
	I am on a page with betting options
 	I cant see the bet
	I log in with username: (.+) and password: (.+)
 	I select a bet
  	"""
	
  Scenario: List current folder sorted descending
	Given a file named "~/Tmp/test_steps.rb" exists
	When I run `stepmom -p ~/Tmp/test_steps.rb list -s DESC`
	Then the stdout should contain:
	"""
	I select a bet
	I log in with username: (.+) and password: (.+)
	I cant see the bet
	I am on a page with betting options
	I am (.*)? on the Homepage
	"""
	
  Scenario: List current folder with keyword
  	Given a file named "~/Tmp/test_steps.rb" exists
  	When I run `stepmom -p ~/Tmp/test_steps.rb list -k`
  	Then the stdout should contain:
  	"""
	Given	I am on a page with betting options
  	When	I select a bet
  	Then	I cant see the bet
  	Given	I am (.*)? on the Homepage
  	Given	I log in with username: (.+) and password: (.+)
  	"""
	
  Scenario: List current folder sorted ascending with keyword
	Given a file named "~/Tmp/test_steps.rb" exists
	When I run `stepmom -p ~/Tmp/test_steps.rb list -s ASC -k`
	Then the stdout should contain:
	"""
	Given	I am (.*)? on the Homepage
	Given	I am on a page with betting options
	Then	I cant see the bet
	Given	I log in with username: (.+) and password: (.+)
	When	I select a bet
	"""
	
  Scenario: List current folder sorted descending with keyword
  	Given a file named "~/Tmp/test_steps.rb" exists
  	When I run `stepmom -p ~/Tmp/test_steps.rb list -s DESC -k`
  	Then the stdout should contain:
  	"""
  	When	I select a bet
  	Given	I log in with username: (.+) and password: (.+)
  	Then	I cant see the bet
  	Given	I am on a page with betting options
  	Given	I am (.*)? on the Homepage
  	"""
	
  Scenario: List file with file info
  	Given a file named "~/Tmp/test_steps.rb" exists
  	When I run `stepmom -p ~/Tmp/test_steps.rb list -f`
  	Then the stdout should contain:
  	"""
	File name:	test_steps.rb
	Last updated:	2016-09-23
	Size:		877 bytes
	Steps:		5 steps

	I am on a page with betting options
	I select a bet
	I cant see the bet
	I am (.*)? on the Homepage
	I log in with username: (.+) and password: (.+)
  	"""
	
  Scenario: List file sorted ascending with file info
	Given a file named "~/Tmp/test_steps.rb" exists
	When I run `stepmom -p ~/Tmp/test_steps.rb list -s ASC -f`
	Then the stdout should contain:
	"""
	File name:	test_steps.rb
	Last updated:	2016-09-23
	Size:		877 bytes
	Steps:		5 steps

	I am (.*)? on the Homepage
	I am on a page with betting options
	I cant see the bet
	I log in with username: (.+) and password: (.+)
	I select a bet
	"""
	
  Scenario: List file sorted descending with file info
  	Given a file named "~/Tmp/test_steps.rb" exists
  	When I run `stepmom -p ~/Tmp/test_steps.rb list -s DESC -f`
  	Then the stdout should contain:
  	"""
	File name:	test_steps.rb
	Last updated:	2016-09-23
	Size:		877 bytes
	Steps:		5 steps

  	I select a bet
  	I log in with username: (.+) and password: (.+)
  	I cant see the bet
  	I am on a page with betting options
  	I am (.*)? on the Homepage
  	"""
	
  Scenario: List folder with file name
  	Given a file named "~/Tmp/test_steps.rb" exists
  	When I run `stepmom -p ~/Tmp list -f`
  	Then the stdout should contain:
  	"""
	test_steps.rb       	I am on a page with betting options
	test_steps.rb       	I select a bet
	test_steps.rb       	I cant see the bet
	test_steps.rb       	I am (.*)? on the Homepage
	test_steps.rb       	I log in with username: (.+) and password: (.+)
  	"""
	
  Scenario: List folder sorted ascending with file name
	Given a file named "~/Tmp/test_steps.rb" exists
	When I run `stepmom -p ~/Tmp list -s ASC -f`
	Then the stdout should contain:
	"""
	test_steps.rb       	I am (.*)? on the Homepage
	test_steps.rb       	I am on a page with betting options
	test_steps.rb       	I cant see the bet
	test_steps.rb       	I log in with username: (.+) and password: (.+)
	test_steps.rb       	I select a bet
	"""
	
  Scenario: List folder sorted descending with file name
  	Given a file named "~/Tmp/test_steps.rb" exists
  	When I run `stepmom -p ~/Tmp list -s DESC -f`
  	Then the stdout should contain:
  	"""
  	test_steps.rb       	I select a bet
  	test_steps.rb       	I log in with username: (.+) and password: (.+)
  	test_steps.rb       	I cant see the bet
  	test_steps.rb       	I am on a page with betting options
  	test_steps.rb       	I am (.*)? on the Homepage
  	"""