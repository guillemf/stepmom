require 'test/unit'
require 'stepmom'

class StepTest < Test::Unit::TestCase

  def setup
  end

  def teardown
  end

  def test_parse_definition_with_single_argument
    newStep = Stepmom::Parser::Step.new('When /^I get help for "([^"]*)"$/ do |app_name|')
    assert_equal 'I get help for "([^"]*)"', newStep.definition
  end
  
  def test_parse_keyword
    newStep = Stepmom::Parser::Step.new('When /^I get help for "([^"]*)"$/ do |app_name|')
    tokenType, tokenContent = newStep.tokens[0]
    assert_equal :keyword, tokenType
    assert_equal :When, tokenContent
  end

  def test_all_steps_should_begin_with_a_keyword
    newStep = Stepmom::Parser::Step.new('/^I get help for "([^"]*)"$/ do |app_name|')
    assert_equal 0, newStep.tokens.count
  end
  
  def test_parse_definition_with_multiple_argument
    newStep = Stepmom::Parser::Step.new('Then /^I should see a message "([^"]*)" and another message "([^"]*)"$/ do |arg1, arg2|')
    assert_equal 'I should see a message "([^"]*)" and another message "([^"]*)"', newStep.definition
  end
  
  def test_get_argument_with_single_argument
    newStep = Stepmom::Parser::Step.new('When /^I get help for "([^"]*)"$/ do |app_name|')
    assert_equal 4, newStep.tokens.count
    
    tokenType, tokenContent = newStep.tokens[1]
    assert_equal :text, tokenType
    assert_equal 'I get help for "', tokenContent
    
    tokenType, tokenContent = newStep.tokens[2]
    assert_equal :argument, tokenType
    assert_equal '([^"]*)', tokenContent
  end

  def test_get_argument_with_multiple_arguments
    newStep = Stepmom::Parser::Step.new('Then /^I should see a message "([^"]*)" and another message "([^"]*)"$/ do |arg1, arg2|')
    assert_equal 6, newStep.tokens.count
    
    tokenType, tokenContent = newStep.tokens[1]
    assert_equal :text, tokenType
    assert_equal 'I should see a message "', tokenContent
    
    tokenType, tokenContent = newStep.tokens[2]
    assert_equal :argument, tokenType
    assert_equal '([^"]*)', tokenContent

    tokenType, tokenContent = newStep.tokens[3]
    assert_equal :text, tokenType
    assert_equal '" and another message "', tokenContent
    
    tokenType, tokenContent = newStep.tokens[4]
    assert_equal :argument, tokenType
    assert_equal '([^"]*)', tokenContent
  end

  def test_get_step_test
    newStep = Stepmom::Parser::Step.new('Then /^I should see a message "([^"]*)" and another message "([^"]*)"$/ do |arg1, arg2|')
    assert_equal 'I should see a message " " and another message " "', newStep.text
  end
  
  def test_get_empty_step_text
    newStep = Stepmom::Parser::Step.new('Then /^$/')
    assert_equal "", newStep.text
  end

  def test_get_step_distance_equals
    newStep1 = Stepmom::Parser::Step.new('Then /^I should see a message "([^"]*)" and another message "([^"]*)"$/ do |arg1, arg2|')
    newStep2 = Stepmom::Parser::Step.new('Then /^I should see a message "([^"]*)" and another message "([^"]*)"$/ do |arg1, arg2|')
    assert_equal 0, newStep1.distance(newStep2)
  end

  def test_get_step_distance_different_contained
    newStep1 = Stepmom::Parser::Step.new('Then /^I should see a message "([^"]*)" and another message "([^"]*)"$/ do |arg1, arg2|')
    newStep2 = Stepmom::Parser::Step.new('Then /^I should see a message "([^"]*)"$/ do |arg1|')
    assert_equal 1, newStep1.distance(newStep2)
  end

  def test_get_step_distance_different
    newStep1 = Stepmom::Parser::Step.new('Then /^I should see a message "([^"]*)" and another message "([^"]*)"$/ do |arg1, arg2|')
    newStep2 = Stepmom::Parser::Step.new('Then /^I shouldn\'t see anything$/ do |arg1|')
    assert_equal 11, newStep1.distance(newStep2)
  end
  
  def test_match_with_no_matching
    newStep = Stepmom::Parser::Step.new('Then /^I should see a message "([^"]*)" and another message "([^"]*)"$/ do |arg1, arg2|')
    assert_false newStep.match("nothing to match")
  end
  
  def test_match_with_matching
    newStep = Stepmom::Parser::Step.new('Then /^I should see a message "([^"]*)" and another message "([^"]*)"$/ do |arg1, arg2|')
    assert_true newStep.match('I should see a message "one" and another message "two"')
  end
  
end
