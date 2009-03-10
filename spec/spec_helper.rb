# ---- requirements
require 'rubygems'
require 'spec'
require 'mocha'
require 'lib/smusher'


# ---- rspec
Spec::Runner.configure do |config|
  config.mock_with :mocha
end


# ---- Helpers
def pending_it(text,&block)
  it text do
    pending(&block)
  end
end