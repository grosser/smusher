task :default do
  sh "rspec spec/"
end

begin
  require 'jeweler'
  Jeweler::Tasks.new do |gem|
    gem.name = 'smusher'
    gem.summary = "Automatic Lossless Reduction Of All Your Images"
    gem.email = "michael@grosser.it"
    gem.homepage = "http://github.com/grosser/#{gem.name}"
    gem.authors = ["Michael Grosser"]
  end

  Jeweler::GemcutterTasks.new
rescue LoadError
  puts "Jeweler, or one of its dependencies, is not available. Install it with: sudo gem install technicalpickles-jeweler -s http://gems.github.com"
end
