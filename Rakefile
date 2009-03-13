desc "Run all specs in spec directory"
task :test do |t|
  require 'spec'
  options = "--colour --format progress --loadby --reverse"
  files = FileList['spec/**/*_spec.rb']
  system("spec #{options} #{files}")
end

#Gemspec
require 'echoe'
project_name = 'smusher'
Echoe.new(project_name , '0.3.4') do |p|
  p.description    = "Automatic Lossless Reduction Of All Your Images"
  p.url            = "http://github.com/grosser/#{project_name}"
  p.author         = "Michael Grosser"
  p.email          = "grosser.michael@gmail.com"
  p.ignore_pattern = ["nbproject/*", "nbproject/*/*"]
  p.dependencies   = %w[rake json httpclient]
end

task :update_gemspec => [:manifest, :build_gemspec]
