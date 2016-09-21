require 'aruba/cucumber'

ENV['PATH'] = "#{File.expand_path(File.dirname(__FILE__) + '/../../bin')}#{File::PATH_SEPARATOR}#{ENV['PATH']}"
LIB_DIR = File.join(File.expand_path(File.dirname(__FILE__)),'..','..','lib')

Before do
  # Using "announce" causes massive warnings on 1.9.2
  @puts = true
  @original_rubylib = ENV['RUBYLIB']
  ENV['RUBYLIB'] = LIB_DIR + File::PATH_SEPARATOR + ENV['RUBYLIB'].to_s
end

After do
  ENV['RUBYLIB'] = @original_rubylib
end

Before '@list_process' do
  file = File.open(File.expand_path("~/Tmp/test_steps.rb"), "w")
  file.puts <<STEP_SAMPLES
Given(/^I am on a page with betting options$/) do
  touch("view id:'homepageTab|0'")
  wait_for_element_exists("my first selection button")
end

When(/^I select a bet$/) do
  if element_does_not_exist("SelectionButton")
    scroll("UICollectionView id:'ScrollItems'", :down)
    wait_for_element_exists("my first selection button")
  end
  touch("SelectionButton index:0")
  wait_for_element_exists("button id:'stakeField'")
end

Then(/^I cant see the bet$/) do
  check_element_exists("button id:'stakeField'")
  touch("SelectionButton index:1")
  wait_for_element_exists("button id:'stakeField2'")
end

STEP_SAMPLES
  file.close unless file.nil?
end