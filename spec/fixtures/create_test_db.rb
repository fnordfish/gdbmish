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

data = {
  "föö"  => "bää\n🤦‍♂️",
  "foo2" => "bar2",
  "foo"  => ("bar-"*128)
}

GDBM.open("test.db", 0666, GDBM::NEWDB) do |db|
  data.each { |k,v| db[k] = v }
end