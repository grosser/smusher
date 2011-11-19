module Smusher
  class SmushIt
    #I leave these urls here, just in case it stops working again...
    # URL = "http://smush.it/ws.php" # original, redirects to somewhere else..
    # URL = "http://developer.yahoo.com/yslow/smushit/ws.php" # official but does not work
    # URL = "http://smushit.com/ysmush.it/ws.php" # used at the new page but does not hande uploads
    # URL = "http://smushit.eperf.vip.ac4.yahoo.com/ysmush.it/ws.php" # used at the new page but does not hande uploads
    # URL = 'http://ws1.adq.ac4.yahoo.com/ysmush.it/ws.php'
    # URL = 'www.smushit.com/ysmush.it/ws.php'

    # How to find a new url:
    # go to the smusher page and look for 'files' in the js source
    # find then url where the 'files' get send + add /ws.php
    URL = 'http://ypoweb-01.experf.gq1.yahoo.com/ysmush.it/ws.php'

    def self.converts_gif_to_png?
      true
    end

    def self.optimized_image_data_for(file)
      response = HTTPClient.post URL, 'files[]' => File.new(file)
      response = JSON.parse(response.body)
      raise "smush.it: #{response['error']}" if response['error']
      image_url = response['dest']
      raise "no dest path found" unless image_url
      open(image_url) { |source| source.read() }
    end
  end
end
