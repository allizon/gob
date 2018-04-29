$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)

require 'gob'
require 'minitest/autorun'
require 'minitest/reporters'
require 'mocha'

Minitest::Reporters.use! Minitest::Reporters::SpecReporter.new

