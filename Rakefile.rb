# frozen_string_literal: true
require 'rubygems'
require 'bundler/setup'
require 'gemma'

Gemma::RakeTasks.with_gemspec_file 'gemma.gemspec'

task :default => :test
