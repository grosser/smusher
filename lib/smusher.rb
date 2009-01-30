require 'rubygems'
require 'rake'
require 'json'

module Smusher
  extend self

  MINIMUM_IMAGE_SIZE = 20#byte

  # optimize the given image !!coverts gif to png!!
  def optimize_image(file)
    puts "THIS FILE IS EMPTY!!! #{file}" and return if size(file).zero?
    with_logging(file) { write_optimized_data(file) }
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
    optimized = optimized_image_data_for(file)
    
    raise "cannot be optimized further" if size(file) == optimized.size
    raise "Error: got larger" if size(file) < optimized.size
    raise "Error: empty file downloaded" if optimized.size < MINIMUM_IMAGE_SIZE

    File.open(file,'w') {|f| f.puts optimized}
  end
  
  def sanitize_folder(folder)
    folder.sub(%r[/$],'')#remove tailing slash
  end

  def images_in_folder(folder)
    folder = sanitize_folder(folder)
    images = %w[png jpg jpeg JPG].map {|ext| "#{folder}/**/*.#{ext}"}
    FileList[*images]
  end
  
  def size(file)
    File.exist?(file) ? File.size(file) : 0
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
    response = JSON.parse(`curl -F files[]=@#{file} http://smush.it/ws.php -s`)
    raise "smush.it: #{response['error']}" if response['error']
    path = response['dest']
    raise "no dest path found" unless path
    `curl http://smush.it/#{path} -s`
  end
end