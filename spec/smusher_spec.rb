ROOT = File.expand_path(File.dirname(__FILE__))
require File.join(ROOT,"spec_helper")

describe :smusher do
  def copy(image_name)
    FileUtils.cp(File.join(ROOT,'images',image_name), @out)
  end

  def size
    File.size(@file)
  end

  before do
    #prepare output folder
    @out = File.join(ROOT,'out')
    FileUtils.rm_r @out, :force=>true
    FileUtils.mkdir @out
    copy 'people.jpg'
    copy 'ad.gif'

    @file = File.join(@out,'people.jpg')
  end

  describe :optimize_image do
    it "stores the image in an reduced size" do
      original_size = size
      Smusher.optimize_image(@file)
      size.should < original_size
    end

    it "it does nothing if size stayed the same" do
      original_size = size
      Smusher.expects(:optimized_image_data_for).returns File.read(@file)
      Smusher.optimize_image(@file)
      size.should == original_size
    end

    it "does not save images whoes size got larger" do
      original_size = size
      Smusher.expects(:optimized_image_data_for).returns File.read(@file)*2
      Smusher.optimize_image(@file)
      size.should == original_size
    end

    it "does not save images if their size is error-sugesting-small" do
      original_size = size
      Smusher.expects(:optimized_image_data_for).returns 'oops...'
      Smusher.optimize_image(@file)
      size.should == original_size
    end

    describe "gif handling" do
      before do
        copy 'logo.gif'
        @file = File.join(@out,'logo.gif')
        @file_png = File.join(@out,'logo.png')
      end

      pending_it "converts gifs to png even if they have the same size" do
        copy 'ad.gif'
        file = File.join(@out,'ad.gif')
        original_size = size
        Smusher.optimize_image(file)
        File.size(File.join(@out,'ad.png')).should == original_size
      end

      it "stores converted .gifs in .png files" do
        Smusher.optimize_image(@file)
        File.exist?(@file).should == false
        File.exist?(@file_png).should == true
      end

      it "does not rename gifs, if optimizing failed" do
        Smusher.expects(:optimized_image_data_for).returns File.read(@file)
        Smusher.optimize_image(@file)
        File.exist?(@file).should == true
        File.exist?(@file_png).should == false
      end
    end

    describe 'options' do
      it "does not produce output when :quiet is given" do
        $stdout.expects(:write).never
        Smusher.optimize_image(@file,:quiet=>true)
      end

      it "raises when an unknown option was given" do
        lambda{Smusher.optimize_image(@file,:q=>true)}.should raise_error
      end
    end
  end

  describe :optimize_images_in_folder do
    before do
      FileUtils.rm @file
      @files = []
      %w[add.png drink_empty.png].each do |image_name|
        copy image_name
        @files << File.join(@out,image_name)
      end
      @before = @files.map {|f|File.size(f)}
    end

    it "optimizes all images" do
      Smusher.optimize_images_in_folder(@out)
      new_sizes = @files.map {|f|File.size(f)}
      new_sizes.size.times {|i| new_sizes[i].should < @before[i]}
    end

    it "does not convert gifs" do
      copy 'logo.gif'
      Smusher.optimize_images_in_folder(@out)
      File.exist?(File.join(@out,'logo.png')).should == false
    end

    it "converts gifs to png when option was given" do
      copy 'logo.gif'
      Smusher.optimize_images_in_folder(@out,:convert_gifs=>true)
      File.exist?(File.join(@out,'logo.png')).should == true
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
      Smusher.send(:with_logging,@file,false) {val = 1}
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
