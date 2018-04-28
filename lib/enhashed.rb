require 'enhashed/version'
require 'enhashed/options'
require 'blank'

module Enhashed
  # Allow us to return an instance of the Options class as the
  # module itself.
  def new(init_options = {})
    Options.new(init_options)
  end

  module_function :new
end

