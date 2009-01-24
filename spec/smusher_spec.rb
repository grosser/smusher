ROOT = File.expand_path(File.dirname(__FILE__))
require File.join(ROOT,"spec_helper")

URL = "http://famfamfam.com/lab/icons/silk/icons/drink_empty.png"
ESCAPED_URL = "http%3A%2F%2Fwww.famfamfam.com%2Flab%2Ficons%2Fsilk%2Ficons%2Fdrink_empty.png"

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
  
  describe :store_smushed_image do
    it "stores the image in an reduced size" do
      original_size = size
      Smusher.store_smushed_image(URL,@file)
      size.should < original_size
    end
    
    it "uses cleaned url" do
      Smusher.expects(:write_smushed_data).with("http://xx",@file)
      Smusher.store_smushed_image('xx',@file)
    end
  end
  
  describe :store_smushed_folder do
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
      Smusher.store_smushed_folder(File.dirname(URL),@out)
      new_sizes = @files.map {|f|File.size(f)}
      puts new_sizes * ' x '
      new_sizes.size.times {|i| new_sizes[i].should < @before[i]}
    end
  end
  
  describe :sanitize_url do
    it "cleans a url" do
      Smusher.send(:sanitize_url,'xx').should == "http://xx"
    end
    
    it "does not cleans a url if it contains a protocol" do
      Smusher.send(:sanitize_url,'ftp://xx').should == "ftp://xx"
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
        @before.should_not == size
      end
      @before.should == size
    end
    
    it "does not revert a file that got created" do
      FileUtils.rm @file
      File.exist?(@file).should be_false
      Smusher.send(:with_protection,@file) do
        copy
      end
      File.exist?(@file).should be_true
    end
    
    it "reverts a file that got empty" do
      Smusher.send(:with_protection,@file) do
        write nil
        size.should == Smusher::EMPTY_FILE_SIZE
      end
      size.should == @before
    end
    
    it "reverts a file that has error-suggesting size" do
      #a file larger that failure data
      write(failure_data+failure_data)
      @before = size
      @before.should > Smusher::SMUSHIT_FAILURE_SIZE
      
      #gets overwritten by failure data size
      Smusher.send(:with_protection,@file) do
        write failure_data
        size.should == Smusher::SMUSHIT_FAILURE_SIZE
      end
      
      #and should be reverted
      size.should_not == Smusher::SMUSHIT_FAILURE_SIZE
      size.should == @before
    end

    it "reverts a file that got created and has error suggesting size" do
      FileUtils.rm @file
      Smusher.send(:with_protection,@file) do
        write failure_data
        File.exist?(@file).should be_true
      end
      File.exist?(@file).should be_false
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
      Smusher.send(:with_logging,URL,@file) {val = 1}
      val.should == 1
    end
  end
  
  describe :smushed_image_data_for do
    it "loads the reduced image" do
      expected_result = File.join(ROOT,'reduced','fam.png')
      received = (Smusher.send(:smushed_image_data_for,URL)+"\n")
      received.should == File.open(expected_result).read
    end
  end
end