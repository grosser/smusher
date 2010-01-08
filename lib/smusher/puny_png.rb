module Smusher
  class PunyPng
    @@api_key = '3cbb0102ca6d000370f2d5b34ca0125d67b801dc'
    def self.api_key=(x); @@api_key = x; end
    def self.api_key; @@api_key; end

    def self.converts_gif_to_png?
      false
    end

    def self.optimized_image_data_for(file)
      url = 'http://www.gracepointafterfive.com/punypng/api/optimize'
      response = HTTPClient.post url, { 'img' => File.new(file), 'key' => api_key}
      response = JSON.parse(response.body.content)
      raise "puny_png: #{response['error']}" if response['error']
      image_url = response['optimized_url']
      raise "no optimized_url found" unless image_url
      open(image_url) { |source| source.read() }
    end
  end
end