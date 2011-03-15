require 'rubygems'
require 'rake'
require 'json'
require 'open-uri'
require 'httpclient'

require 'smusher/smush_it'
require 'smusher/puny_png'

module Smusher
  extend self

  MINIMUM_IMAGE_SIZE = 20#byte

  VERSION = File.read( File.join(File.dirname(__FILE__),'..','VERSION') ).strip

  # optimize the given image
  # converts gif to png, if size is lower
  # can be called with a file-path or an array of files-paths
  def optimize_image(files,options={})
    service = options[:service] || 'SmushIt'
    service = eval(service)

    Array(files).each do |file|
      check_options(options)
      puts "THIS FILE IS EMPTY!!! #{file}" and return if size(file).zero?

      with_logging(file,options[:quiet]) do
        write_optimized_data(file, service)
      end
    end
  end

  # fetch all jpg/png images from  given folder and optimize them
  def optimize_images_in_folder(folder, options={})
    check_options(options)
    images_in_folder(folder, options[:convert_gifs]).each do |file|
      optimize_image(file, options)
    end
  end

  private

  def check_options(options)
    known_options = [:convert_gifs, :quiet, :service]
    if options.detect{|k,v| not known_options.include?(k)}
      raise "Known options: #{known_options*' '}"
    end
  end

  def write_optimized_data(file, service)
    optimized = service.optimized_image_data_for(file)

    raise "Error: got larger" if size(file) < optimized.size
    raise "Error: empty file downloaded" if optimized.size < MINIMUM_IMAGE_SIZE
    raise "cannot be optimized further" if size(file) == optimized.size

    File.open(file,'wb') {|f| f.write optimized}

    if service.converts_gif_to_png? && File.extname(file) == ".gif" && optimized[0..2] != "GIF"
      `mv #{file} #{file.sub(/.gif$/, '.png')}`
    end
  end

  def sanitize_folder(folder)
    folder.sub(%r[/$],'')#remove tailing slash
  end

  def images_in_folder(folder,with_gifs=false)
    folder = sanitize_folder(folder)
    images = %w[png jpg jpeg JPG]
    images << 'gif' if with_gifs
    images.map! {|ext| "#{folder}/**/*.#{ext}"}
    FileList[*images]
  end

  def size(file)
    File.exist?(file) ? File.size(file) : 0
  end

  def with_logging(file, quiet)
    if quiet
      yield rescue nil
    else
      puts "smushing #{file}"

      before = size(file)
      yield rescue puts($!)
      after = size(file)

      result = "#{(100*after)/before}%"
      puts "#{before} -> #{after}".ljust(40) + " = #{result}"
      puts ''
    end
  end
end
