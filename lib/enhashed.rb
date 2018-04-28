require 'enhashed/version'
require 'enhashed/hash'
require 'blank'

module Enhashed
  # Allow us to return an instance of the Options class as the
  # module itself.
  def new(init_options = {})
    Hash.new(init_options)
  end

  module_function :new
end

