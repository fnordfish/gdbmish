#!/usr/bin/env ruby
# frozen_string_literal: true

# Using the Ruby GDBM bindings as a conivinient way of creating
# some test data

require "bundler"
require "bundler/inline"

Bundler.settings.temporary(frozen: false, deployment: false) do
  gemfile do
    source "https://rubygems.org"
    platform "ruby" do
      gem 'gdbm'
    end
  end
end

require 'gdbm'

DATA = eval(File.read(File.join(__dir__, "data.rb")))

GDBM.open(File.join(__dir__, "test.db"), 0666, GDBM::NEWDB) do |db|
  DATA.each { |k,v| db[k] = v }
end