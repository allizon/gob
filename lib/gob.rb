require 'gob/version'
require 'gob/generic_object'
require 'blank'

module Gob
  # Allow us to return an instance of the GenericObject class as the
  # module itself.
  def new(init_options = {})
    GenericObject.new(init_options)
  end

  module_function :new
end

