require 'rubygems'
require 'rake'
require 'json'

module Smusher
  extend self
  EMPTY_FILE_SIZE = 4
  
  def store_smushed_image(file)
    raise if size(file) <= EMPTY_FILE_SIZE
    with_protection(file) do
      with_logging(file) do
        write_smushed_data(file)
      end
    end
  end

  def store_smushed_folder(folder)
    images_in_folder(folder).each do |file|
      store_smushed_image(file)
      puts ''
    end
  end

private

  def write_smushed_data(file)
    data = smushed_image_data_for(file)
    File.open(file,'w') {|f| f.puts data}
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
    after = size(file)

    if after <= EMPTY_FILE_SIZE or after >= before
      FileUtils.mv(backup,file,:force=>true)#revert
      puts "reverted!"
    else
      FileUtils.rm(backup)
    end
  end
  
  def size(file)
    File.exist?(file) ? File.size(file) : 0
  end

  def with_logging(file)
    puts "sushing #{file}"
    before = size(file)
    yield
    after = size(file)
    
    result = before == 0 ?  "CREATED" : "#{(100*after)/before}%"
    puts "#{before} -> #{after}".ljust(40) + " = #{result}"
  end

  def smushed_image_data_for(file)
    data = `curl -F files[]=@#{file} http://smush.it/ws.php -s`
    return nil if data['error']
    path = "/#{JSON.parse(data)['dest']}"
    #TODO use rest-client --> independent of curl
    data = `curl http://smush.it#{path} -s`
  end
end