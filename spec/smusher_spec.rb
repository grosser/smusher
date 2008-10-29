root = File.expand_path(File.dirname(__FILE__))
require File.join(root,"spec_helper")

URL = "http://famfamfam.com/lab/icons/silk/icons/drink_empty.png"
ESCAPED_URL = "http%3A%2F%2Fwww.famfamfam.com%2Flab%2Ficons%2Fsilk%2Ficons%2Fdrink_empty.png"

describe :smusher do
  before do
    @s = Smusher.new
    @file = File.join(root,'out','fam.png') 
  end
  
  describe :store_smushed_image do
    it "stores the image in an reduced size" do
      original_size = 433
      @s.store_smushed_image(URL,@file)
      File.size(@file).should < original_size
    end
    
    it "uses cleaned url" do
      @s.expects(:write_smushed_data).with("http://xx",@file)
      @s.store_smushed_image('xx',@file)
    end
  end
  
  describe :sanitize_url do
    it "cleans a url" do
      @s.send(:sanitize_url,'xx').should == "http://xx" 
    end
    
    it "does not cleans a url if it contains a protocol" do
      @s.send(:sanitize_url,'ftp://xx').should == "ftp://xx" 
    end
  end
  
  describe :sanitize_folder do
    it "cleans a folders trailing slash" do
      @s.send(:sanitize_folder,"xx/").should == 'xx'
    end
    
    it "does not clean if there is no trailing slash" do
      @s.send(:sanitize_folder,"/x/ccx").should == '/x/ccx'
    end
  end
  
  describe :images_in_folder do
    it "finds all images" do
      folder = File.join(root,'images')
      all = %w[book.png people.jpg water.JPG woman.jpeg].map{|f|"#{folder}/#{f}"}
      result = @s.send(:images_in_folder,folder)
      all.each {|f|result.include?(f).should be_true}
    end
    
    it "finds nothing if folder is empty" do
      @s.send(:images_in_folder,File.join(root,'empty')).should == []
    end
  end
end

