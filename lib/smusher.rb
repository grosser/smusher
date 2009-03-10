require 'rubygems'
require 'rake'
require 'json'

module Smusher
  extend self

  # optimize the given image !!coverts gif to png!!
  def optimize_image(file)
    if empty?(file)
      puts "THIS FILE IS EMPTY!!! #{file}"
      return
    end
    with_protection(file) do
      with_logging(file) do
        write_optimized_data(file)
      end
    end
  end

  # fetch all jpg/png images from  given folder and optimize them
  def optimize_images_in_folder(folder)
    images_in_folder(folder).each do |file|
      optimize_image(file)
      puts ''
    end
  end

private

  def write_optimized_data(file)
    data = optimized_image_data_for(file)
    File.open(file,'w') {|f| f.puts data} unless data.nil?
  end
  
  def sanitize_folder(folder)
    folder.sub(%r[/$],'')#remove tailing slash
  end

  def images_in_folder(folder)
    folder = sanitize_folder(folder)
    images = %w[png jpg jpeg JPG].map {|ext| "#{folder}/**/*.#{ext}"}
    FileList[*images]
  end
  
  def with_protection(file)
    backup = "#{file}.backup"
    FileUtils.cp(file,backup)

    before = size(file)
    yield

    if empty?(file) or size(file) >= before
      FileUtils.mv(backup,file,:force=>true)#revert
      puts "reverted!"
    else
      FileUtils.rm(backup)
    end
  end
  
  def size(file)
    File.exist?(file) ? File.size(file) : 0
  end

  def empty?(file)
    size(file) <= 4 #empty file = 4kb
  end

  def with_logging(file)
    puts "smushing #{file}"
    
    before = size(file)
    begin; yield; rescue; puts $!; end
    after = size(file)
    
    result = "#{(100*after)/before}%"
    puts "#{before} -> #{after}".ljust(40) + " = #{result}"
  end

  def optimized_image_data_for(file)
    #TODO use rest-client --> independent of curl
    response = JSON.parse(`curl -F files[]=@#{file} http://smush.it/ws.php?gifconvert=force -s`)
    raise "smush.it: #{response['error']}" if response['error']
    path = response['dest']
    raise "no dest path found" unless path
    `curl http://smush.it/#{path} -s`
  end
end