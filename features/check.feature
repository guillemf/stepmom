# Feature: We can perform a check on step files
# 	As a developer I want to keep a DRY and effective list of step definitions
# 	ensuring I don't have repeated tests or too similar ones.
#
#   @optimization
#   Scenario: Check without params
# 	Given a file named "~/Tmp/test_steps.rb" exists
# 	And a file named "~/Tmp/duplicated_steps.rb" exists
# 	When I run `stepmom -p ~/Tmp check`
# 	Then the stderr should contain "error: Please select one of the valid options"
#
#
#   Scenario: Search without param value regex
# 	Given a file named "~/Tmp/test_steps.rb" exists
# 	And a file named "~/Tmp/duplicated_steps.rb" exists
# 	When I run `stepmom -p ~/Tmp/duplicated_steps.rb check`
#   	Then the stderr should contain "error: missing argument: -r"
