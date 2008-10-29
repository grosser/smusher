root = File.expand_path(File.dirname(__FILE__))
require File.join(root,"spec_helper")

URL = "http://famfamfam.com/lab/icons/silk/icons/drink_empty.png"
ESCAPED_URL = "http%3A%2F%2Fwww.famfamfam.com%2Flab%2Ficons%2Fsilk%2Ficons%2Fdrink_empty.png"

describe :store_smushed_image do
  it "stores the image in an reduced size" do
    old_size = 433
    file = File.join(root,'out','fam.png')
    Smusher.new.store_smushed_image(URL,file)
    File.size(file).should < old_size
  end
end