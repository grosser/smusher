require 'rubygems'
require 'rake'

class Smusher
  #http://smushit.com/ws.php?img=http%3A%2F%2Fwww.famfamfam.com%2Flab%2Ficons%2Fsilk%2Ficons%2Fdrink_empty.png&task=89266837334214400&id=paste2
  SMUSHIT_FAILURE_SIZE = 9667  
  
  def store_smushed_image(url,file)
    url = sanitize_url(url)
    with_protection(file) do
      with_logging(url,file) do
        write_smushed_data(url,file)
      end
    end
  end

  def store_smushed_folder(base_url,folder)
    base_url = sanitize_url(base_url)
    folder = sanitize_folder(folder)
    
    images_in_folder(folder).each do |file|
      relative_path_to_folder = file.sub(folder+'/','')
      url = "#{base_url}/#{relative_path_to_folder}"
      store_smushed_image(url,file)
      puts ''
    end
  end

private

  def write_smushed_data(url,file)
    File.open(file,'w') do |f|
      data = smushed_image_data_for(url)
      raise data if data =~ /<html>/i
      f.puts data
    end
  end

  def sanitize_url(url)
    url = url.sub(%r[/$],'')#remove tailing slash
    url = url.sub(url,"http://#{url}") unless url.include?('://')#add http if protocol is missing
    url
  end
  
  def sanitize_folder(folder)
    folder.sub(%r[/$],'')#remove tailing slash
  end

  def images_in_folder(folder)
    images = %w[png jpg jpeg JPG].map {|ext| "#{folder}/**/*.#{ext}"}
    FileList[*images]
  end
  
  def with_protection(file)
    return yield unless File.exist?(file)
    
    backup = "#{file}.backup"
    FileUtils.cp(file,backup)#backup
    
    before = size(file)
    yield
    after = size(file)
    
    if after == SMUSHIT_FAILURE_SIZE or after > before
      FileUtils.mv(backup,file,:force=>true)#revert
      puts "reverted!"
    else
      FileUtils.rm(backup)
    end
  end
  
  def size(file)
    File.exist?(file) ? File.size(file) : 0
  end

  def with_logging(url,file)
    puts "sushing #{url} -> #{file}"
    
    before = size(file)
    yield(file)
    after = size(file)
    
    result = before == 0 ?  "CREATED" : "#{(100*after)/before}%"
    puts "#{before} -> #{after}".ljust(40) + " = #{result}"
  end

  def smushed_image_data_for(url)
    require 'cgi'
    url = CGI.escape url
    
    require 'net/http'
    require 'net/https'
    require 'rubygems'
    require 'json'
    
    http = Net::HTTP.new('smushit.com')
    path = "/ws.php?img=#{url}&task=89266837334214400&id=paste2"
    
    resp, data = http.get(path, nil)
    raise "oops #{resp}" unless resp.is_a? Net::HTTPOK
    
    path = "/#{JSON.parse(data)['dest']}"
    resp, data = http.get(path, nil)
    data
  end
end