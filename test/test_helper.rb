require 'rubygems'
require 'bundler/setup'
require 'test/unit'
require 'mocha/setup'

class ApplicationController
  def self.before_filter(*args)
    # just stubbing this out
  end
end

require 'secure_api'
require 'secure_api/api_token_test'