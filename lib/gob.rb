require 'gob/version'
require 'gob/enhanced_hash'
require 'blank'

module Gob
  # Allow us to return an instance of the Options class as the
  # module itself.
  def new(init_options = {})
    EnhancedHash.new(init_options)
  end

  module_function :new
end

