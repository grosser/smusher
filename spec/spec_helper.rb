# ---- requirements
require 'rubygems'
require 'spec'
require 'mocha'

$LOAD_PATH << 'lib'
require 'smusher'

ROOT = File.expand_path(File.dirname(__FILE__))

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