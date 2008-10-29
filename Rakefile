require 'rubygems'
require 'rake'
require 'lib/smusher'

desc 'Default: run spec.'
task :default => :smush

desc "Smush em"
task :smush do
  file = ENV['FILE'].to_s.strip
  folder = ENV['FOLDER'].to_s.strip
  url = ENV['URL'].to_s.strip
  if (file=='' and folder=='') or url==''
    raise "rake FILE=xxx.jpg URL=www.x.com/xxx.jpg OR rake FOLDER=images URL=www.x.com/"
  end
  if file != '' and File.
    Smusher.new.store_smushed_image(url,file)
  elsif folder != '' and File.directory?(folder)
    Smusher.new.store_smushed_folder(url,folder)
  else
    raise
  end
end

desc "Run all specs in spec directory"
task :spec do |t|
  require 'spec'
  options = "--colour --format progress --loadby --reverse"
  files = FileList['spec/**/*_spec.rb']
  system("spec #{options} #{files}")
end