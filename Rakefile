desc "Run all specs in spec directory"
task :test do |t|
  require 'spec'
  options = "--colour --format progress --loadby --reverse"
  files = FileList['spec/**/*_spec.rb']
  system("spec #{options} #{files}")
end

#Gemspec
require 'echoe'
porject_name = 'smusher'
Echoe.new(porject_name , '0.3.1') do |p|
  p.description    = "Automatic Lossless Reduction Of All Your Images"
  p.url            = "http://github.com/grosser/#{porject_name}"
  p.author         = "Michael Grosser"
  p.email          = "grosser.michael@gmail.com"
  p.dependencies   = %w[rake json]
end

task :update_gemspec => [:manifest, :build_gemspec]