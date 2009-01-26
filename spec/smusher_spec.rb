ROOT = File.expand_path(File.dirname(__FILE__))
require File.join(ROOT,"spec_helper")

describe :smusher do
  def size
    File.size(@file)
  end
  
  before do
    #prepare output folder
    @out = File.join(ROOT,'out')
    FileUtils.rm_r @out, :force=>true
    FileUtils.mkdir @out
    FileUtils.cp(File.join(ROOT,'images','people.jpg'), @out)
    
    @file = File.join(@out,'people.jpg')
  end
  
  describe :optimize_image do
    it "stores the image in an reduced size" do
      original_size = size
      Smusher.optimize_image(@file)
      size.should < original_size
    end
  end
  
  describe :optimize_images_in_folder do
    before do
      FileUtils.rm @file
      @files = []
      %w[add.png drink_empty.png].each do |name|
        file = File.join(ROOT,'images',name)
        @files << File.join(@out,name) 
        FileUtils.cp file, @out
      end
      @before = @files.map {|f|File.size(f)} 
    end
    
    it "smushes all images" do
      Smusher.optimize_images_in_folder(@out)
      new_sizes = @files.map {|f|File.size(f)}
      puts new_sizes * ' x '
      new_sizes.size.times {|i| new_sizes[i].should < @before[i]}
    end
  end
  
  describe :sanitize_folder do
    it "cleans a folders trailing slash" do
      Smusher.send(:sanitize_folder,"xx/").should == 'xx'
    end
    
    it "does not clean if there is no trailing slash" do
      Smusher.send(:sanitize_folder,"/x/ccx").should == '/x/ccx'
    end
  end
  
  describe :images_in_folder do
    it "finds all non-gif images" do
      folder = File.join(ROOT,'images')
      all = %w[add.png drink_empty.png people.jpg water.JPG woman.jpeg].map{|name|"#{folder}/#{name}"}
      result = Smusher.send(:images_in_folder,folder)
      (all+result).uniq.size.should == all.size
    end
    
    it "finds nothing if folder is empty" do
      Smusher.send(:images_in_folder,File.join(ROOT,'empty')).should == []
    end
  end
  
  describe :with_protection do
    def failure_data 
      'x' * (Smusher::SMUSHIT_FAILURE_SIZE-1)
    end
    
    def write(data)
      File.open(@file,'w') {|f|f.puts data}
    end
    
    def copy
      FileUtils.cp(File.join(ROOT,'images','people.jpg'),@file)
    end
    
    before do
      @before = size
      @before.should_not == 0
    end
    
    it "reverts a file that got larger" do
      Smusher.send(:with_protection,@file) do
        write(File.open(@file).read + 'x')
      end
      @before.should == size
    end
    
    it "reverts a file that got empty" do
      Smusher.send(:with_protection,@file){write nil}
      size.should == @before
    end
  end
  
  describe :size do
    it "find the size of a file" do
      Smusher.send(:size,@file).should == File.size(@file)
    end
    
    it "returns 0 for missing file" do
      Smusher.send(:size,File.join(ROOT,'xxxx','dssdfsddfs')).should == 0
    end
  end
  
  describe :logging do
    it "yields" do
      val = 0
      Smusher.send(:with_logging,@file) {val = 1}
      val.should == 1
    end
  end
  
  describe :optimized_image_data_for do
    it "loads the reduced image" do
      original = File.join(ROOT,'images','add.png')
      reduced = File.open(File.join(ROOT,'reduced','add.png')).read
      received = (Smusher.send(:optimized_image_data_for,original))
      received.should == reduced
    end
  end
end